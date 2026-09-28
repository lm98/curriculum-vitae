#import "template.typ": *

#let cv = yaml("cv.yaml")

#show: setup.with(name: cv.name)

#header(cv.name, cv.headline, cv.contacts)
#summary(cv.summary)

#section("Experience")
#experience(cv.experience)

#section("Projects")
#projects(cv.projects)

#section("Skills")
#skills(cv.skills)

#section("Publications")
#publications(cv.publications)

#section("Education")
#education(cv.education)
