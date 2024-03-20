import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  const OptionTile({super.key,  required this.option, 
                                required this.description, 
                                required this.optionSelected});

  final String option, description, optionSelected;
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.description == widget.optionSelected ? Colors.black.withOpacity(0.7) : Colors.grey,
              width: 1.4,
            ),
            color: widget.description == widget.optionSelected ? Colors.grey : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            "${widget.option}",
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: 
          Text(
            widget.description,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
        )
        
      ],
    ),
  );
}
}

class NoOfQuestionTile extends StatefulWidget {
  final String text;
  final int number;

  NoOfQuestionTile({required this.text, required this.number});

  @override
  _NoOfQuestionTileState createState() => _NoOfQuestionTileState();
}

class _NoOfQuestionTileState extends State<NoOfQuestionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14)
              ),
              color: Colors.blue
            ),
            child: Text(
              "${widget.number}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              color: Colors.black54
            ),
            child: Text(
              widget.text,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}