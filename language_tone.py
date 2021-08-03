#IBM Libraries

from ibm_watson import LanguageTranslatorV3, TextToSpeechV1, ToneAnalyzerV3
from ibm_cloud_sdk_core.authenticators import IAMAuthenticator




#IBM Credentials

## Translator
apikey = "HIigk6bEQN_AA8R79uMmRlpMILxxcKIiKxcm8OetHbFl"
url = 'https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/63187563-1323-48c2-a632-f1217214a9b7'

## Tone Analyzer

oapikey = '29IjB8aksQx0bK3IsYxNM8-iPrR5xVz5vsPJk7BPOSH8'
ourl = 'https://api.eu-gb.tone-analyzer.watson.cloud.ibm.com/instances/58bbded9-add0-4fde-93ee-070a855b2ceb'


#Setup Services

authenticator = IAMAuthenticator(apikey)
lt = LanguageTranslatorV3(version='2020-05-19',authenticator=authenticator)

lt.set_service_url(url)

# Functions
def lang_identifier(text):
	'''Language Identifier detect the language by listed ISO639-I'''
	language = lt.identify(text).get_result()
	language = language['languages'][0]['language']
	return language

# Detected language convert to English
#model = language + '-en'

def lang_translator(text,model):
	translation = lt.translate(text,model_id=model).get_result()
	#Getting Translation in Targeted Language
	translation = translation['translations'][0]['translation']
	print(translation)
	return translation


def tone_analyzer(text):
	# Tone Authenticator to analyze emotion on the basis of NLP by Proccessed Text.
	authenticator = IAMAuthenticator(oapikey)
	ta = ToneAnalyzerV3(version='2020-05-20',authenticator=authenticator)

	ta.set_service_url(ourl)
	tone_ana = ta.tone(text).get_result()
	#print(tone_ana)
	return tone_ana['document_tone']['tones']

