class BatchesController < ApplicationController
  before_filter :assign_ticket_kinds_or_redirect, :only => [:new, :create, :index, :show]

  # GET /batches
  # GET /batches.xml
  def index
    @batches = Batch.ordered

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @batches }
    end
  end

  # GET /batches/1
  # GET /batches/1.xml
  def show
    @batch = Batch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @batch }
    end
  end

  # GET /batches/new
  # GET /batches/new.xml
  def new
    @batch = Batch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @batch }
    end
  end

  # POST /batches
  # POST /batches.xml
  def create
    @batch = Batch.new(params[:batch])

    respond_to do |format|
      if @batch.save
        flash[:notice] = 'Batch was successfully created.'
        format.html { redirect_to(@batch) }
        format.xml  { render :xml => @batch, :status => :created, :location => @batch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @batch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1
  # DELETE /batches/1.xml
  def destroy
    @batch = Batch.find(params[:id])
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to(batches_path) }
      format.xml  { head :ok }
    end
  end

  protected

  # Set @ticket_kinds variable or redirect to new ticket kind form if none are available.
  def assign_ticket_kinds_or_redirect
    if TicketKind.count == 0
      flash[:error] = "You must create at least one kind of ticket before creating tickets."
      redirect_to new_ticket_kind_path
    else
      @ticket_kinds = TicketKind.ordered
    end
  end
end
