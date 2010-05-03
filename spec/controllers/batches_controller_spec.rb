require 'spec_helper'

describe BatchesController do

  before :each do
    login_as_admin
  end

  shared_examples_for "with or without ticket kinds" do
    # FIXME really
  end

  describe "with ticket kinds" do
    it_should_behave_like "with or without ticket kinds"

    before :each do
      @ticket_kinds = [Factory(:ticket_kind), Factory(:ticket_kind)]
    end

    describe "new" do
      it "should display new batch form" do
        get :new
        response.should be_success
        flash[:error].should be_blank
      end
    end

    describe "create" do
      before do
        stub_notifier_secrets
      end

      it "should create batch when given valid params" do
        lambda do
          post :create, :batch => Factory.attributes_for(:batch, :ticket_kind => @ticket_kinds.first, :emails => "foo@bar.com\nbaz@qux.org")
        end.should change(Ticket, :count).by(2)

        response.should redirect_to(batch_path(assigns[:batch].id))
        assigns[:batch].should be_valid
        flash[:error].should be_blank

        assigns[:batch].tickets.each do |ticket|
          ticket.status.should == "sent_email"
        end
      end

      it "should not create a batch when given invalid params"  do
        attributes = Factory.attributes_for :batch, :ticket_kind => nil
        post :create, :batch => attributes

        response.should be_success
        assigns[:batch].should_not be_valid
      end
    end

    describe "index" do
      it "should list empty set" do
        Batch.destroy_all
        get :index
        response.should be_success
        assigns[:batches] == []
      end

      it "should list batches" do
        batches = [Factory(:batch), Factory(:batch)]
        get :index
        response.should be_success
        assigns[:batches] == batches
      end
    end

    describe "show" do
      it "should show batch" do
        batch = Factory :batch
        get :show, :id => batch.id
        response.should be_success
        assigns[:batch] == batch
      end

      describe "for JSON" do
        before do
          @batch = Factory :batch
          @tickets = @batch.tickets
          @ticket = @tickets.first
          get :show, :id => @batch.id, :format => "json"
          @data = response_json
        end
        
        describe "for batch" do
          it "should include attributes" do
            @data['batch']['ticket_kind_id'].should == @batch.ticket_kind_id
          end

          it "should include selected methods" do
            @data['batch']['done?'].should == @batch.done?
          end
          
          it "should not include unselected methods" do
            @data['batch']['ticket_kind'].should be_nil
          end
        end

        describe "for tickets" do
          before do
             @ticket_data = @data['batch']['tickets'].first
             @ticket = @batch.tickets.detect{ |ticket| ticket.id == @ticket_data['id'] }
          end

          it "should include attributes" do
            @ticket_data['status'].should == @ticket.status
          end

          it "should include selected methods" do
            @ticket_data['status_label'].should == @ticket.status_label
          end

          it "should not include unselected methods" do
            @ticket_data['send_email'].should be_nil
          end
        end
      end
    end

    describe "destroy" do
      it "should destroy batch" do
        batch = Factory :batch
        delete :destroy, :id => batch.id
        response.should redirect_to(batches_path)
        assigns[:batch] == batch
        Batch.exists?(batch.id).should == false
      end
    end
  end

  describe "without ticket kinds" do
    it_should_behave_like "with or without ticket kinds"

    describe "new" do
      it "should demand that ticket kinds be created first" do
        get :new
        response.should redirect_to(new_ticket_kind_path)
        flash[:error].should_not be_blank
      end
    end

    describe "create" do
      it "should demand that ticket kinds be created first" do
        post :create, :batch => Factory.attributes_for(:batch, :ticket_kind => nil)
        response.should redirect_to(new_ticket_kind_path)
        flash[:error].should_not be_blank
      end
    end

    describe "index" do
      it "should demand that ticket kinds be created first" do
        get :index
        response.should redirect_to(new_ticket_kind_path)
        flash[:error].should_not be_blank
      end
    end
  end

=begin
def mock_batch(stubs={})
    @mock_batch ||= mock_model(Batch, stubs)
  end

  describe "GET index" do
    it "assigns all batches as @batches" do
      Batch.stub(:find).with(:all).and_return([mock_batch])
      get :index
      assigns[:batches].should == [mock_batch]
    end
  end

  describe "GET show" do
    it "assigns the requested batch as @batch" do
      Batch.stub(:find).with("37").and_return(mock_batch)
      get :show, :id => "37"
      assigns[:batch].should equal(mock_batch)
    end
  end

  describe "GET new" do
    it "assigns a new batch as @batch" do
      Batch.stub(:new).and_return(mock_batch)
      get :new
      assigns[:batch].should equal(mock_batch)
    end
  end

  describe "GET edit" do
    it "assigns the requested batch as @batch" do
      Batch.stub(:find).with("37").and_return(mock_batch)
      get :edit, :id => "37"
      assigns[:batch].should equal(mock_batch)
    end
  end

  describe "POST create" do

    it "should create a batch when given valid params" do
      batch = Factory :batch
      Batch.should_receive(:new).with(batch.attributes).and_return(batch)
      batch.should_receive(:save).and_return(true)

      post :create, :batch => batch.attributes

      response.should redirect_to(batch_path batch)
      assigns[:batch].should be_valid
    end

    it "should not create a batch when given invalid params"  do
      attributes = Factory.attributes_for :batch, :ticket_kind => nil
      post :create, :batch => attributes

      response.should be_success
      assigns[:batch].should_not be_valid
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested batch" do
        Batch.should_receive(:find).with("37").and_return(mock_batch)
        mock_batch.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :batch => {:these => 'params'}
      end

      it "assigns the requested batch as @batch" do
        Batch.stub(:find).and_return(mock_batch(:update_attributes => true))
        put :update, :id => "1"
        assigns[:batch].should equal(mock_batch)
      end

      it "redirects to the batch" do
        Batch.stub(:find).and_return(mock_batch(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(batch_url(mock_batch))
      end
    end

    describe "with invalid params" do
      it "updates the requested batch" do
        Batch.should_receive(:find).with("37").and_return(mock_batch)
        mock_batch.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :batch => {:these => 'params'}
      end

      it "assigns the batch as @batch" do
        Batch.stub(:find).and_return(mock_batch(:update_attributes => false))
        put :update, :id => "1"
        assigns[:batch].should equal(mock_batch)
      end

      it "re-renders the 'edit' template" do
        Batch.stub(:find).and_return(mock_batch(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested batch" do
      Batch.should_receive(:find).with("37").and_return(mock_batch)
      mock_batch.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the batches list" do
      Batch.stub(:find).and_return(mock_batch(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(batches_url)
    end
  end
=end

end
