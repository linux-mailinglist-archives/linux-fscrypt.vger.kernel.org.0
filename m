Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C634E737D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Mar 2022 13:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358032AbiCYMdT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Mar 2022 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355069AbiCYMcv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Mar 2022 08:32:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0953CD080C;
        Fri, 25 Mar 2022 05:31:17 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PAS6J6013215;
        Fri, 25 Mar 2022 12:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=goJB0SCqo5d39ZSNDAI7BU78CtP+9thRdvFF6R5J+wc=;
 b=A+wnsv4VInGsI6YKMTOyxSPCHej84JaylddJWXa6MNlPUx0Wutle5qE/uTtPREa9YZb9
 u/Os8thesgO5U5ciDqL1QqPsk/qbbGBXBPWfsIgC7puN8G/ICeJo1fCGPxZ3t4Gck6KM
 E3tzjsYeHV9uhBxcqJPmJeCtMCvBOKp7Z33Wv6eDrUfNN4Y4l/Vr3WasrdwaRhpr/Rgt
 Pcexh1lNbtQOdnVLOtayrI52YF5sVkF4uUTXKktRkYur9y4qX2RGBaFlPDPf1XMyxPHs
 XTXWGAhyC5y3Ca2WycRvnzusp3PHRnJ3eQoHHrzE+iSE2XY0kj3N71Q3U5AiojyGWeeY qA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0t26y2pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 12:31:14 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PCD6SS026663;
        Fri, 25 Mar 2022 12:31:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ej3aqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 12:31:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PCVA9N54985002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 12:31:10 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4583C11C04A;
        Fri, 25 Mar 2022 12:31:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A8E011C04C;
        Fri, 25 Mar 2022 12:31:09 +0000 (GMT)
Received: from sig-9-65-72-52.ibm.com (unknown [9.65.72.52])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 12:31:09 +0000 (GMT)
Message-ID: <9bda9c8a9f161763f420bf8e7bd639fe0d7e1691.camel@linux.ibm.com>
Subject: Re: [PATCH v6 4/5] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Mar 2022 08:31:08 -0400
In-Reply-To: <d79baf40-6bb7-d4f4-666d-91e1ad20be74@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
         <20220318182151.100847-5-zohar@linux.ibm.com>
         <d79baf40-6bb7-d4f4-666d-91e1ad20be74@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6RIghj8AlccUgY2wbnH3it5WzrtsKJa8
X-Proofpoint-GUID: 6RIghj8AlccUgY2wbnH3it5WzrtsKJa8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-03-21 at 09:10 -0400, Stefan Berger wrote:
> 
> On 3/18/22 14:21, Mimi Zohar wrote:
> > IMA may verify a file's integrity against a "good" value stored in the
> > 'security.ima' xattr or as an appended signature, based on policy.  When
> > the "good value" is stored in the xattr, the xattr may contain a file
> > hash or signature.  In either case, the "good" value is preceded by a
> > header.  The first byte of the xattr header indicates the type of data
> > - hash, signature - stored in the xattr.  To support storing fs-verity
> > signatures in the 'security.ima' xattr requires further differentiating
> > the fs-verity signature from the existing IMA signature.
> > 
> > In addition the signatures stored in 'security.ima' xattr, need to be
> > disambiguated.  Instead of directly signing the fs-verity digest, a new
> > signature version 3 is defined as the hash of the ima_file_id structure,
> > which identifies the type of signature and the digest.
> 
> Would it not be enough to just differentiat by the type of signature 
> rather than also bumping the version? It's still signature_v2_hdr but a 
> new type IMA_VERITY_DIGSIG is introduced there that shoud be sufficient 
> to indicate that a different method for calculating the hash is to be 
> used than for anything that existed before? sigv3 would then become the 
> more obvious veriftysig... ?

One of Eric's concerns was that, "an attacker (who controls the file's
contents and IMA xattr) [could] replace the file with one with a
differrent content and still be able to pass the IMA check."  His
solution was to only allow one signature version on a running system.  
For the complete description of the attack, refer to Eric's comments on
v3.

Instead of only allowing one signature version on a running system,
subsequent versions of this patch set addressed his concern, by
limiting the signature version based on policy.

-- 
thanks,

Mimi

