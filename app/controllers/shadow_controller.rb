class ShadowController < ApplicationController

    def index
        @requests = ShadowRequest.new   
    end    

end
