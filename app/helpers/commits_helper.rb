module CommitsHelper
    def short_hash
        commit_hash[0..7]
    end    

    def completion_color
        completion_ratio >= 100 ? 'success' : 'warning'
    end

    def score_icon
        score >= 0 ? 'ok text-success' : 'remove text-danger'
    end

    def score_color
        score >= 0 ? 'green' : 'red'
    end 
end
