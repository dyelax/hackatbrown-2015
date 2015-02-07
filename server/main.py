import os.path

from flask import Flask
import jinja2 as j

env = j.Environment(loader=j.FileSystemLoader(os.path.dirname(__file__)),
extensions=['jinja2.ext.autoescape'], autoescape=True)

app = Flask(__name__)
app.config.from_object("config")

@app.route('/')
def get():
	template = env.get_template("static/index.html")
	return template.render()

if __name__ == "__main__":
	app.run()
