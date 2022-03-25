Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3646C4E747E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Mar 2022 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358370AbiCYNv2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Mar 2022 09:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358499AbiCYNv1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Mar 2022 09:51:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97F1D0824;
        Fri, 25 Mar 2022 06:49:52 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PCwOrf012056;
        Fri, 25 Mar 2022 13:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SWB1fRPssbUSIoi+2GNNbJc4k5vldoJwJL0bBzN0E6U=;
 b=oZT6+piEVH9PDdlam8zzBQ7B7z4YqQg/n4GjO+hHUKnEMADLi+F/OSA/sbrEOyK/IKLg
 w+u7nJN7Hgj4B8VTMvhEkHC1aYPlCumZ1VrbGG9sTyAvxXM3g3E5tXvnR7Kr2Jvl331S
 JtNYDrHHk1CRYM7KfjQBzRFUDBlAst8+43JILgpOFmEOIYRD86c/vTdR2wiHnJhxboFs
 R3iJAoCYPl7OIW5SBUYMW0veer4iJ7/BTG2khTq8CNco7BmGHwvhYdqDvS/VXcn5d/Zg
 7V4cPpFe6NZYndUKC0nXXr0rtgIRMYSleki/EvSz3mD5LcDXyn0Lvrfc5B62r71s5UlX QA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0sd4jvsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 13:49:49 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PDmS7K010791;
        Fri, 25 Mar 2022 13:49:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3ew6tapqg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 13:49:48 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PDnkS134603268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 13:49:47 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D166BAE06D;
        Fri, 25 Mar 2022 13:49:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3EA7AE062;
        Fri, 25 Mar 2022 13:49:46 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 13:49:46 +0000 (GMT)
Message-ID: <dc791477-27cb-63c1-c9ee-11d7b1274c6c@linux.ibm.com>
Date:   Fri, 25 Mar 2022 09:49:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 4/5] ima: support fs-verity file digest based version 3
 signatures
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318182151.100847-1-zohar@linux.ibm.com>
 <20220318182151.100847-5-zohar@linux.ibm.com>
 <d79baf40-6bb7-d4f4-666d-91e1ad20be74@linux.ibm.com>
 <9bda9c8a9f161763f420bf8e7bd639fe0d7e1691.camel@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <9bda9c8a9f161763f420bf8e7bd639fe0d7e1691.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oasaLqmPZ2GsW3SElYDM0F7BGaZe7-sS
X-Proofpoint-ORIG-GUID: oasaLqmPZ2GsW3SElYDM0F7BGaZe7-sS
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_02,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 3/25/22 08:31, Mimi Zohar wrote:
> On Mon, 2022-03-21 at 09:10 -0400, Stefan Berger wrote:
>>
>> On 3/18/22 14:21, Mimi Zohar wrote:
>>> IMA may verify a file's integrity against a "good" value stored in the
>>> 'security.ima' xattr or as an appended signature, based on policy.  When
>>> the "good value" is stored in the xattr, the xattr may contain a file
>>> hash or signature.  In either case, the "good" value is preceded by a
>>> header.  The first byte of the xattr header indicates the type of data
>>> - hash, signature - stored in the xattr.  To support storing fs-verity
>>> signatures in the 'security.ima' xattr requires further differentiating
>>> the fs-verity signature from the existing IMA signature.
>>>
>>> In addition the signatures stored in 'security.ima' xattr, need to be
>>> disambiguated.  Instead of directly signing the fs-verity digest, a new
>>> signature version 3 is defined as the hash of the ima_file_id structure,
>>> which identifies the type of signature and the digest.
>>
>> Would it not be enough to just differentiat by the type of signature
>> rather than also bumping the version? It's still signature_v2_hdr but a
>> new type IMA_VERITY_DIGSIG is introduced there that shoud be sufficient
>> to indicate that a different method for calculating the hash is to be
>> used than for anything that existed before? sigv3 would then become the
>> more obvious veriftysig... ?
> 
> One of Eric's concerns was that, "an attacker (who controls the file's
> contents and IMA xattr) [could] replace the file with one with a

Reference: 
https://lore.kernel.org/linux-integrity/20220126000658.138345-1-zohar@linux.ibm.com/T/#m8929fa29fbdfc875dbf5f384a4c082d303d2040e

This seem to describe the root user. A restrictions of root's power 
maybe that root may not have access to the file signing key use on the 
local system... ?

> differrent content and still be able to pass the IMA check."  His

Is this a scenario of concern? : /usr/bin/foobar is signed by verity and 
there's a rule in the IMA policy that would appraise this file. Can root 
now remove /usr/bin/foobar and copy the regularly signed /usr/bin/bash 
to /usr/bin/foobar along with bash's security.ima and have it execute 
either since there's no appraise rule covering non-fsverity signatures 
or due to a rule that covers non-fsverity signatures?

Since the signature header of security.ima is not signed root could also 
just rewrite the header and modify the signature type (and also version) 
and circumvent appraisal rules specific to fsverity.

> solution was to only allow one signature version on a running system.
> For the complete description of the attack, refer to Eric's comments on
> v3.


I am trying to figure out a concrete scenario that one has to defend 
against what seems to be the power of the root user. A more concrete 
example may be helpful.

> 
> Instead of only allowing one signature version on a running system,
> subsequent versions of this patch set addressed his concern, by
> limiting the signature version based on policy.
> 
