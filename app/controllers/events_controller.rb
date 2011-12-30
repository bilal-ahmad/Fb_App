class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    #@events = Event.all
    if params[:user].present? and params[:user] == "cc"  or admin_signed_in?
    @events = Event.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
    else
      redirect_to validate_user_path
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if params[:user].present? and params[:user] == "cc"  or admin_signed_in?
      @event = Event.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @event }
      end
    else
      redirect_to validate_user_path
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate_event
    activated_event = Event.find_by_active(true)
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attribute("active", true)
        activated_event.update_attribute("active", false) if activated_event
        format.html { redirect_to events_path }
        format.json { head :ok }
      else
        format.html { render action: "index" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end
