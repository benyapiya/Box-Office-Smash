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

# save the model to disk
filename = '/tmp/src/Box-Office-Smash/notebooks/gbm_2.joblib'

# the model expect 95 features
TESTDATA = StringIO("""productionbudget;runtimeminutes;release_year;release_week;g_rating;pg_rating;pg13_rating;r_rating;action;comedy;drama;adventure;biography;horror;crime;documentary;animation;romance;mystery;thriller;scifi;fantasy;family;threed;animallead;dysfunctionalfamily;africanamerican;marvelcomics;religious;talkinganimals;visualeffects;revenge;male_lead;matt_damon;nicolas_cage;owen_wilson;samuel_l_jackson;mark_wahlberg;adam_sandler;denzel_washington;dwayne_johnson;gerard_butler;george_clooney;ben_stiller;robert_de_niro;bruce_willis;will_smith;ben_affleck;will_ferrell;tom_hanks;tom_cruise;keanu_reeves;leonardo_dicaprio;jake_gyllenhaal;steve_carell;johnny_depp;matthew_mcconaughey;jason_statham;vin_diesel;robert_downey_jr;christian_bale;reese_witherspoon;russell_crowe;ice_cube;sandra_bullock;jackie_chan;cate_blanchett;brad_pitt;john_goodman;channing_tatum;jim_carrey;jack_black;colin_farrell;hugh_jackman;stephen_soderbergh;ridley_scott;steven_spielberg;ron_howard;tim_burton;clint_eastwood;shawn_levy;michael_bay;m_night_shyamalan;martin_scorsese;peter_jackson;guy_ritchie;david_gordon_green;christopher_nolan;todd_phillips;warner_bros;universal;fox;buena_vista;sony;paramount
    2000000.0;129.0;2011.0;39.0;0.0;0.0;0.0;1.0;0.0;0.0;1.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;1.0;0.0;0.0;0.0;1.0;0.0;0.0;0.0;0.0;0.0;0.0;1.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0
    """)

df = pd.read_csv(TESTDATA, sep=";")

# load the model from disk
loaded_model = joblib.load(filename)
result = loaded_model.predict(df)
print(result)