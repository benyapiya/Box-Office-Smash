from textblob import TextBlob
from flask import Flask, request, jsonify, render_template
from flask_cors import CORS
from sklearn import model_selection
from sklearn.linear_model import LogisticRegression
from sklearn.externals import joblib
import psycopg2
import pandas as pd

import numpy as np

from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from joblib import dump, load

from sklearn.model_selection import train_test_split
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler

from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.linear_model import ElasticNetCV
from sklearn.linear_model import LassoLars

from sklearn.model_selection import RandomizedSearchCV
import sys
if sys.version_info[0] < 3: 
    from StringIO import StringIO
else:
    from io import StringIO

from bitarray import bitarray

from bokeh.embed import components
from bokeh.plotting import figure
from bokeh.resources import INLINE
from bokeh.util.string import encode_utf8

app = Flask(__name__)
CORS(app)


@app.route("/exec_ml", methods=['GET','POST'])
def exec_ml():
    production_budget = request.args.get('production_budget')
    runtimemins = request.args.get('runtimemins')
    release_year = request.args.get('release_year')
    release_week = request.args.get('release_week')
    rating = addSemicolon(request.args.get('rating'))
    genre_1 = request.args.get('genre_1')
    genre_2 = request.args.get('genre_2')
    genre_3 = request.args.get('genre_3')
    genre_4 = request.args.get('genre_4')
    actor_1 = request.args.get('actor_1')
    actor_2 = request.args.get('actor_2')
    actor_3 = request.args.get('actor_3')
    actor_4 = request.args.get('actor_4')
    director = addSemicolon(request.args.get('director'))
    studio = addSemicolon(request.args.get('studio'))
    genre = addSemicolon(set_bit(24, genre_1, genre_2, genre_3, genre_4))
    actor = addSemicolon(set_bit(41, actor_1, actor_2, actor_3, actor_4))

    input_str = production_budget+";"+runtimemins+";"+release_year+";"+release_week+";"+rating+";"+genre+";1;"+actor+";"+director+";"+studio

    INPUTDATA = StringIO()
    INPUTDATA.write('productionbudget;runtimeminutes;release_year;release_week;g_rating;pg_rating;pg13_rating;r_rating;action;comedy;drama;adventure;biography;horror;crime;documentary;animation;romance;mystery;thriller;scifi;fantasy;family;threed;animallead;dysfunctionalfamily;africanamerican;marvelcomics;religious;talkinganimals;visualeffects;revenge;male_lead;matt_damon;nicolas_cage;owen_wilson;samuel_l_jackson;mark_wahlberg;adam_sandler;denzel_washington;dwayne_johnson;gerard_butler;george_clooney;ben_stiller;robert_de_niro;bruce_willis;will_smith;ben_affleck;will_ferrell;tom_hanks;tom_cruise;keanu_reeves;leonardo_dicaprio;jake_gyllenhaal;steve_carell;johnny_depp;matthew_mcconaughey;jason_statham;vin_diesel;robert_downey_jr;christian_bale;reese_witherspoon;russell_crowe;ice_cube;sandra_bullock;jackie_chan;cate_blanchett;brad_pitt;john_goodman;channing_tatum;jim_carrey;jack_black;colin_farrell;hugh_jackman;stephen_soderbergh;ridley_scott;steven_spielberg;ron_howard;tim_burton;clint_eastwood;shawn_levy;michael_bay;m_night_shyamalan;martin_scorsese;peter_jackson;guy_ritchie;david_gordon_green;christopher_nolan;todd_phillips;warner_bros;universal;fox;buena_vista;sony;paramount\n')
    INPUTDATA.write(input_str+'\n')
    print("DEBUG MESSAGE: ")
    print(INPUTDATA.getvalue())
    INPUTDATA.seek(0)
    return load_model(INPUTDATA)

def set_bit(num_bit, val_1, val_2, val_3, val_4):
    s = num_bit*bitarray('0')
    s[int(val_1)] = 1
    s[int(val_2)] = 1
    s[int(val_3)] = 1
    s[int(val_4)] = 1
    str_out = str(s).replace("bitarray('","")
    str_out = str_out.replace("')","")
    return str_out

def addSemicolon(val_1):
    val = ""
    for c in val_1:
        if val == "":
            val=c
        else:
            val=val+";"+c
    return val

def load_model(fileio_input):
    filename = '/tmp/src/Box-Office-Smash/notebooks/gbm_2.joblib'

    df = pd.read_csv(fileio_input, sep=";")

    # load the model from disk
    loaded_model = joblib.load(filename)
    result = loaded_model.predict(df)
    return str(f'{round(result[0]):,}')

@app.route('/bokeh')
def bokeh():

    # init a basic bar chart:
    # http://bokeh.pydata.org/en/latest/docs/user_guide/plotting.html#bars
    fig = figure(plot_width=600, plot_height=600)
    fig.vbar(
        x=[1, 2, 3, 4],
        width=0.5,
        bottom=0,
        top=[1.7, 2.2, 4.6, 3.9],
        color='navy'
    )

    # grab the static resources
    js_resources = INLINE.render_js()
    css_resources = INLINE.render_css()

    # render template
    script, div = components(fig)
    html = render_template(
        'bokeh.html',
        plot_script=script,
        plot_div=div,
        js_resources=js_resources,
        css_resources=css_resources,
    )
    return encode_utf8(html)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)