# Brimir is a helpdesk system to handle email support requests.
# Copyright (C) 2012-2014 Ivaldi http://ivaldi.nl
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class TicketsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  #load_and_authorize_resource :ticket, except: [:index, :create]
  skip_authorization_check only: [:create, :index, :show, :update, :new]

  def show
    @ticket = Ticket.find(params[:id])
    @agents = User.agents

    @reply = @ticket.replies.new
    @reply.to = @ticket.sender_email
  end

  def index
    @agents = User.agents

    params[:status] ||= 'open'

    # TODO: filter status
    @tickets = Ticket.by_status(params[:status])
      .search(params[:q])
      .filter_by_assignee_id(params[:assignee_id])
      .page(params[:page])
      .ordered

      #.viewable_by(current_user)

    #if @tickets.count > 0
    #  @tickets.each do |ticket|
    #    authorize! :index, ticket
    #  end
    #else
    #  authorize! :index, Ticket
    #end
  end

  def update
    @ticket = Ticket.find(params[:id])
    respond_to do |format|
      if @ticket.update_attributes(ticket_params)

        # assignee set and not same as user who modifies
        if !@ticket.assignee.nil? && @ticket.assignee.id != current_user.id

          if @ticket.previous_changes.include? :assignee_id
            TicketMailer.notify_assigned(@ticket).deliver

          elsif @ticket.previous_changes.include? :status
            TicketMailer.notify_status_changed(@ticket).deliver

          elsif @ticket.previous_changes.include? :priority
            TicketMailer.notify_priority_changed(@ticket).deliver
          end

        end

        format.html {
          redirect_to @ticket, notice: 'Ticket was successfully updated.'
        }
        format.js {
          render notice: 'Ticket was succesfully updated.'
        }
        format.json {
          head :no_content
        }
      else
        format.html {
          render action: 'edit'
        }
        format.json {
          render json: @ticket.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def new
    @ticket = Ticket.new
  end

  def create
    respond_to do |format|
      format.html do
        @ticket = Ticket.new({
            sender_email: params["headers"] ? params["headers"]["From"] : params[:ticket][:sender_email],
            content:      params[:plain] || params[:ticket][:content],
            category:     (params[:ticket][:category] if params[:ticket]),
            subject:      params["headers"] ? params["headers"]["Subject"] : params[:ticket][:subject]
        })

        #@ticket.user = current_user
        #@ticket.to = current_user.incoming_address

        if @ticket.save!
          #TicketMailer.notify_agents(@ticket, @ticket).deliver

          redirect_to ticket_url(@ticket), notice: 'Ticket created succesfully'
        else
          render 'new'
        end
      end
      format.json do
        @ticket = TicketMailer.receive(params[:message])
        render json: @ticket, status: :created
      end
      format.js { render }
    end
  end

  private
    def ticket_params
      if current_user.agent?
        params.require(:ticket).permit(
            :content,
            :user_id,
            :subject,
            :status,
            :assignee_id,
            :priority,
            :message_id)
      else
        params.require(:ticket).permit(
            :content,
            :subject,
            :priority)
      end
    end
end
