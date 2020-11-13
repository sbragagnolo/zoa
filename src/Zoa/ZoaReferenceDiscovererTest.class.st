Class {
	#name : #ZoaReferenceDiscovererTest,
	#superclass : #TestCase,
	#category : #'Zoa-Test'
}

{ #category : #tests }
ZoaReferenceDiscovererTest >> testInitialDiscovererHasInvalidDefaultArticle [

	self assert: ZoaSBReferenceDiscoverer new currentArticle name equals: 'N/A'
]

{ #category : #tests }
ZoaReferenceDiscovererTest >> testInitialDiscovererIsEmpty [

	self assert: ZoaSBReferenceDiscoverer new isEmpty
]
