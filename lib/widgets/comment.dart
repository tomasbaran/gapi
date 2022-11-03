import 'package:flutter/material.dart';
import 'package:gapi/theme/style_constants.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            padding: EdgeInsets.all(12),
            // color: kGreen,
            color: Colors.black45,
            child: Text(
              'Rsitenrsi aistenars airstna irsetnaisetna isetna istnairstnaisretnairstnaist airs rsetniarsent. sret irsnt aisten ars.ta setn airst arstears.t r.st ras.t.ars t. rst tts tst.',
              style: tsReviewCategoryComment,
            ),
          ),
        ),
        Text(
          '24.10.2022: 79%',
          style: tsReviewCategoryCommentDate,
        ),
      ],
    );
  }
}
