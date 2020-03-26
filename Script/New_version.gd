extends RichTextLabel

#unc _ready():
#	connect("meta_clicked", self, "meta_clicked");

func meta_clicked(_meta):
	var _err = OS.shell_open("https://www.V1-Games.com");
