package edu.uci.swe264p.retrofit;


import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.ImageView;
import androidx.recyclerview.widget.RecyclerView;
import com.squareup.picasso.Picasso;
import java.util.List;

public class MovieListAdapter extends RecyclerView.Adapter<MovieListAdapter.ViewHolder> {
    private static final String IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500";
    private List<Movie> mData;
    MovieListAdapter(List<Movie> data) {
        this.mData = data;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        ImageView ivMovie;
        TextView tvTitle;
        TextView tvReleaseDate;
        TextView tvVote;
        TextView tvOverview;

        ViewHolder(View itemView) {
            super(itemView);
            ivMovie = itemView.findViewById(R.id.ivMovie);
            tvTitle = itemView.findViewById(R.id.tvTitle);
            tvReleaseDate = itemView.findViewById(R.id.tvReleaseDate);
            tvVote = itemView.findViewById(R.id.tvVote);
            tvOverview = itemView.findViewById(R.id.tvOverview);
        }
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.movie_row, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Movie movie = mData.get(position);
        holder.tvTitle.setText(movie.getTitle());
        holder.tvReleaseDate.setText(movie.getReleaseDate());
        holder.tvVote.setText(String.valueOf(movie.getVoteAverage()));
        holder.tvOverview.setText(movie.getOverview());

        String posterPath = movie.getPosterPath();
        if (posterPath != null && !posterPath.isEmpty()) {
            Picasso.get()
                    .load(IMAGE_BASE_URL + posterPath)
                    .into(holder.ivMovie);
        } else {
            holder.ivMovie.setImageDrawable(null);
        }
    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

}
