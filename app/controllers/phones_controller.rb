class PhonesController < ApplicationController
  before_action :set_phone, only: [:show] #, :edit, :update, :destroy]

  # GET /phones
  # GET /phones.json
  def index
    records_per_page = 20 # constant for now
    @count = Phone.count
    @page_count = @count / records_per_page
    @page = 1
    int_page = params[:page].to_i
    if (int_page.is_a? Integer and int_page > 0 and int_page <= @page_count)
      @page = int_page
    end
    @phones = Phone.offset((@page -1) * records_per_page).limit(records_per_page)
    respond_to do |format|
      format.html
      format.json { render :json => @phones }
    end
  end

  # GET /phones/carrier.json
  def carrier
    @phones = Phone.by_carrier_metric

    respond_to do |format|
      format.json { render :json => @phones }
    end
  end

  # GET /phones/manufacturer.json
  def manufacturer
    @phones = Phone.by_manufacturer_metric

    respond_to do |format|
      format.json { render :json => @phones }
    end
  end

  # GET /phones/price.json
  def price
    @phones = Phone.by_price_metric

    respond_to do |format|
      format.json { render :json => @phones }
    end
  end

  # GET /phones/1
  # GET /phones/1.json
  def show
    @id = params[:id].to_i
    @max_id = Phone.count
  end

  # GET /phones/new
  def new
    @phone = Phone.new
  end

  # GET /phones/1/edit
  def edit
  end

  # POST /phones
  # POST /phones.json
  def create
    @phone = Phone.new(phone_params)

    respond_to do |format|
      if @phone.save
        format.html { redirect_to @phone, notice: 'Phone was successfully created.' }
        format.json { render action: 'show', status: :created, location: @phone }
      else
        format.html { render action: 'new' }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phones/1
  # PATCH/PUT /phones/1.json
  def update
    respond_to do |format|
      if @phone.update(phone_params)
        format.html { redirect_to @phone, notice: 'Phone was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @phone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phones/1
  # DELETE /phones/1.json
  def destroy
    @phone.destroy
    respond_to do |format|
      format.html { redirect_to phones_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone
      @phone = Phone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_params
      params.require(:phone).permit(:page, :name, :shortDescription, :largeImage, :manufacturer, :regularPrice, :bestSellingRank, :salesRankShortTerm, :salesRankMediumTerm, :salesRankLongTerm, :classId)
    end
end
