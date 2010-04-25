require 'spec_helper'

describe BatchesController do

  before :each do
    login_as_admin
  end

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

end
