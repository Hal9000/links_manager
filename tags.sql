select links.title, links.link, tags.tag, tag_scores.score from links join tag_scores on tag_scores.link_id = links.id join tags on tag_scores.tag_id = tags.id;
