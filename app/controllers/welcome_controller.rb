class WelcomeController < ApplicationController
  def index
  end
  
  def ajax_method_from_link_to
    @data = params[:data]
    
    respond_to do |format|
      format.html { redirect_to welcome_index_url }
      format.json { render :no_contrent }
      format.js { render layout: false }
    end
  end
  
  def ajax_method_from_js
    @data = params[:data]
    @value = params[:value]
    
    #response = JSON.pretty_generate(data: @data)
    
    respond_to do |format|
      #format.json { render json: response }
      format.json { render json: {data: @data, value: @value.reverse}}
    end
  end
end
