#stupid scaffold_controller pluralization....
class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]

  # GET /homes
  # GET /homes.json
  def index
  end
  def gallery
    imageCount = 0
    pageCount = 0
    #@gifs = ["http://i.imgur.com/AUFDta8.gif", "http://i.imgur.com/u1t7FgH.gif", "http://i.imgur.com/m3i1P.gif", "http://i.imgur.com/VANDhe7.gif", "http://i.imgur.com/0z7pboO.gif", "http://i.imgur.com/NPQJBbp.gif"]
    @gifs = []

    while imageCount < 6
      reddit = open("http://www.reddit.com/r/Eyebleach/.json?limit=100&count=#{pageCount * 25}") { |f| f.read } 
      puts "#{pageCount * 25}"
      data = JSON.parse(reddit)
      data["data"]["children"].each do |datum|
        if /.gif/.match(datum["data"]["url"]) && datum["data"]["thumbnail"] != "nsfw"
          gif = datum["data"]["url"]
          @gifs << gif
          #do processing here
          `wget #{gif}  -P /home/lee/src/eyebleach/test_images/`
          puts "GIFFF!!!!! #{gif}"
          filename = File.basename("#{gif}")
          basename = File.basename("#{gif}", ".gif")
          `convert /home/lee/src/eyebleach/test_images/#{filename} /home/lee/src/eyebleach/test_images/#{basename}-frame%01d.gif`
          imageCount = imageCount + 1
        end
      end
      pageCount = pageCount + 1
    end
  end

  # GET /homes/1
  # GET /homes/1.json
  def show
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
  end

  # POST /homes
  # POST /homes.json
  def create
    @home = Home.new(home_params)

    respond_to do |format|
      if @home.save
        format.html { redirect_to @home, notice: 'Home was successfully created.' }
        format.json { render action: 'show', status: :created, location: @home }
      else
        format.html { render action: 'new' }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homes/1
  # PATCH/PUT /homes/1.json
  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to @home, notice: 'Home was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    @home.destroy
    respond_to do |format|
      format.html { redirect_to homes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home
      @home = Home.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_params
      params[:home]
    end
end
