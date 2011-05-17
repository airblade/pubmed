#!/usr/bin/env ruby -w

# Loads a list of common gastro-intestinal diagnoses.

while line = DATA.gets
  symptom, code = line.split ','
  code.strip!
  puts "#{symptom}: #{code}"
end

__END__
abdominal pain,789
right upper quadrant abdominal pain,789.01
right upper quadrant pain,789.01
left upper quadrant abdominal pain,789.02
left upper quadrant pain,789.02
right lower quadrant abdominal pain,789.03
right lower quadrant pain,789.03
left lower quadrant abdominal pain,789.04
left lower quadrant pain,789.04
periumbilical abdominal pain,789.05
perimumbilical pain,789.05
epigastric abdominal pain,789.06
epigastric pain,789.06
constipation,564
diarrhea,564.5
dyspepsia,536.8
dysphagia,787.2
fatigue,780.79
malaise,780.79
heartburn,787.1
incontinence,787.6
feces incontinence,787.6
nausea and vomiting,787.01
nausea,787.02
ascites,789.59
rectal pain,569.42
weight gain,783.1
weight loss,783.21
iron deficiency,280.9
hematemesis,578
hematochezia,578.1
melena,578.1
rectal bleed,569.3
anal bleed,569.3
anal fissure,565
colitis,558.9
Crohn's,555.9
irritable bowel syndrome,564.1
diverticulitis,562.11
colon motility disorder,564.9
pruritus ani,698
proctitis,556.2
proctosigmoiditis,556.3
left-sided ulcerative colitis,556.5
universal ulcerative colitis,556.6
achalasia,530
barrett's esophagus,530.85
esophagitis,530.1
GERD,530.81
gastroesophageal reflux disease,530.81
abnormal liver function test,790.5
alcoholic cirrhosis,571.2
alcoholic liver damage,571.3
biliary cirrhosis,571.6
biliary obstruction,576.2
cirrhosis,571.5
cholecystitis,575.12
hepatitis,573.3
gastric ulcer,531
duodenal ulcer,532
peptic ulcer,533
gastrojejunal ulcer,534
gastritis,535
duodenitis,535.6
gastroparesis,536.3
enteritis,555
ileus,560.1
perianal abscess,566
peritonitis,567
psoas muscle abscess,567.31
peritoneal adhesions,568
intestinal malabsorption,579
celiac disease,579
coeliac disease,579
tropical sprue,579.1
blind loop syndrome,579.2
short bowel syndrome,579.3
appendicitis,540
gastroenteritis,558.9
abdominal distension,787.3
bloating,787.3
