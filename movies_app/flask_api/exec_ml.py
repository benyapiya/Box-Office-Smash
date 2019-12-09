from textblob import TextBlob
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route("/exec_ml", methods=['GET','POST'])
def exec_ml():
    movie_name = request.args.get('movie_name')
    movie_actor = request.args.get('movie_actor')
    movie_desc = request.args.get('movie_desc')
    movie_genre = request.args.get('movie_genre')
    movie_studio = request.args.get('movie_studio')

    # to combine 4 genres and 5 actors
    # productionbudget	1
    # runtimeminutes	1
    # release_year	1 ()
    # release_week	1 (1-52)
    # rating	4
    # genre	24
    # male_lead	1
    # actor	41
    # director	15
    # studio	6

    out_str = movie_name+"boo"+movie_actor+"boo"+movie_desc+"boo"+movie_genre+"boo"+movie_studio+"boo"
    return out_str


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)