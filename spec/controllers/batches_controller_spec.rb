require 'spec_helper'

describe BatchesController do

  before :each do
    @controller.send(:authenticate=, false)
    @controller.send(:authentication_kind=, :basic)
  end

  def mock_batch(stubs={})
    @mock_batch ||= mock_model(Batch, stubs)
  end

  describe "authentication" do
    describe "when enabled" do
      before :each do
        @controller.send(:authenticate=, true)
      end

      describe "using basic" do
        before :each do
          @controller.send(:authentication_kind=, :basic)
        end

        it "should allow access given valid credentials" do
          pending "TODO figure out how to login via HTTP Basic Auth" # TODO
          request.env['HTTP-AUTHENTICATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(SECRETS.username, SECRETS.password)
          get :index, nil, :authorization => ActionController::HttpAuthentication::Basic.encode_credentials(SECRETS.username, SECRETS.password)

          response.should be_success
        end

        it "should not allow access given invalid credentials" do
          get :index, nil, :authorization => ActionController::HttpAuthentication::Basic.encode_credentials("invalid_username", "invalid_password")

          response.code.should == "401"
        end

        it "should not allow access without credentials" do
          get :index

          response.code.should == "401"
        end
      end

      describe "using digest" do
        before :each do
          @controller.send(:authentication_kind=, :digest)
        end

        it "should allow access given valid credentials" do
          authenticate_with_http_digest(SECRETS.username, SECRETS.password, SECRETS.realm)

          get :index

          response.should be_success
        end

        it "should not allow access given invalid credentials" do
          authenticate_with_http_digest("invalid_username", "invalid_password", "invalid_realm")

          get :index

          response.code.should == "401"
        end

        it "should not allow access without credentials" do
          get :index

          response.code.should == "401"
        end
      end
    end

    describe "when disabled" do
      it "should allow access" do
        get :index

        response.should be_success
      end
    end
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
