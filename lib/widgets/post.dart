import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Post extends StatefulWidget {
  final Submission submission;

  Post({Key key, this.submission}) : super(key: key);

  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  VoteState votedState;
  bool saved;

  @override
  void initState() {
    this.votedState = widget.submission.vote;
    this.saved = widget.submission.saved;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = (widget.submission.preview.length > 0)
        ? widget.submission.preview.elementAt(0).source.url.toString()
        : '';

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  imageUrl != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            imageUrl,
                            height: MediaQuery.of(context).size.width * 0.56279,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  Text(widget.submission.title,
                      maxLines: 3, style: TextStyle(fontSize: 25)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'r/' + widget.submission.subreddit.displayName,
                          style:
                              TextStyle(fontSize: 15, color: Colors.redAccent),
                        ),
                        Text(
                          ' - ',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'u/' + widget.submission.author,
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueAccent),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.submission.upvotes.toString() + ' Votes',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        ' - ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        widget.submission.numComments.toString() + ' Comments',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_upward,
                            color: this.votedState == VoteState.upvoted
                                ? Colors.red
                                : null,
                            size: 30,
                          ),
                          onTap: () {
                            setState(() {
                              VoteState newVoteState =
                                  this.votedState == VoteState.upvoted
                                      ? VoteState.none
                                      : VoteState.upvoted;
                              this.votedState = newVoteState;
                              if (newVoteState == VoteState.upvoted)
                                widget.submission.upvote();
                              else
                                widget.submission.clearVote();
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            child: Icon(Icons.arrow_downward,
                                color: this.votedState == VoteState.downvoted
                                    ? Colors.blue
                                    : null,
                                size: 30),
                            onTap: () {
                              setState(() {
                                VoteState newVoteState =
                                    this.votedState == VoteState.downvoted
                                        ? VoteState.none
                                        : VoteState.downvoted;
                                this.votedState = newVoteState;
                                if (newVoteState == VoteState.downvoted)
                                  widget.submission.downvote();
                                else
                                  widget.submission.clearVote();
                              });
                            },
                          ),
                        ),
                        GestureDetector(
                          child: Icon(this.saved ? Icons.favorite : Icons.favorite_border,
                              color: this.saved ? Colors.yellow : null,
                              size: 30),
                          onTap: () {
                            setState(() {
                              if(this.saved) {
                                widget.submission.unsave();
                                this.saved = false;
                              } else {
                                widget.submission.save();
                                this.saved = true;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
