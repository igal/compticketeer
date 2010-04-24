class TicketKindsController < ApplicationController
  # GET /ticket_kinds
  # GET /ticket_kinds.xml
  def index
    @ticket_kinds = TicketKind.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ticket_kinds }
    end
  end

  # GET /ticket_kinds/1
  # GET /ticket_kinds/1.xml
  def show
    @ticket_kind = TicketKind.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket_kind }
    end
  end

  # GET /ticket_kinds/new
  # GET /ticket_kinds/new.xml
  def new
    @ticket_kind = TicketKind.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ticket_kind }
    end
  end

  # GET /ticket_kinds/1/edit
  def edit
    @ticket_kind = TicketKind.find(params[:id])
  end

  # POST /ticket_kinds
  # POST /ticket_kinds.xml
  def create
    @ticket_kind = TicketKind.new(params[:ticket_kind])

    respond_to do |format|
      if @ticket_kind.save
        flash[:notice] = 'TicketKind was successfully created.'
        format.html { redirect_to(@ticket_kind) }
        format.xml  { render :xml => @ticket_kind, :status => :created, :location => @ticket_kind }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket_kind.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ticket_kinds/1
  # PUT /ticket_kinds/1.xml
  def update
    @ticket_kind = TicketKind.find(params[:id])

    respond_to do |format|
      if @ticket_kind.update_attributes(params[:ticket_kind])
        flash[:notice] = 'TicketKind was successfully updated.'
        format.html { redirect_to(@ticket_kind) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket_kind.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_kinds/1
  # DELETE /ticket_kinds/1.xml
  def destroy
    @ticket_kind = TicketKind.find(params[:id])
    @ticket_kind.destroy

    respond_to do |format|
      format.html { redirect_to(ticket_kinds_url) }
      format.xml  { head :ok }
    end
  end
end
