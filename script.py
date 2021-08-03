# Language Detection and Analytics System

from language_tone import *
from nltk.classify import textcat 
#mport goslate

# Lang as dict

line = {'hi':'Hindi','hif':'Fiji Hindi','ru':'Russian','abk':'Abkhazian','epo':'Esperanto',
'spa':'Spanish','osp':'Old Spanish','ko':'Korean', 'ar':'Arabic','zh':'Chinese (Simplified)','cnr':'Montenegrin [2]'
,'zh-TW':'Chinese (Traditional)'  ,	'ne':'Nepali','gu':'Gujarati','ta':'Tamil','he':'Hebrew','te':'Telugu','en':'English'}

Text = input(str("Enter the Text: "))


classifier = textcat.TextCat()

distances = classifier.lang_dists(Text)
# #print(input_text)
ans = classifier.guess_language(Text)


# Goslate Language Detector

# gs = goslate.Goslate()
# lan_id = gs.detect(Text)





language = lang_identifier(Text)

txt =  '(ISO639-3) Code: ' + language
res = " ".join(line.get(ele, ele) for ele in txt.split())
# print("Detected Language: ",gs.get_languages()[lan_id], res)
print(res,ans)

# print("Detected Language Code:", language )

model = language + '-en'


if language == 'en':
	tone = tone_analyzer(Text)

	print("Tone Analysis is:", tone,type(tone))
	
else:
	translation = lang_translator(Text,model)

	tone = tone_analyzer(translation)

	print("Tone Analysis is:", tone,type(tone))

