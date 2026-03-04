package edu.uci.swe264p.retrofit;
import com.google.gson.annotations.SerializedName;
import java.util.List;

public class TopRatedResponse {
    @SerializedName("results")
    private List<Movie> results;

    public TopRatedResponse(List<Movie> results) {
        this.results = results;
    }

    public List<Movie> getResults() {
        return results;
    }
}