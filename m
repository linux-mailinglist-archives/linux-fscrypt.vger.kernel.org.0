Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27DD4C3229
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Feb 2022 17:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiBXQvi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Feb 2022 11:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiBXQvi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Feb 2022 11:51:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5247BD2C5;
        Thu, 24 Feb 2022 08:51:07 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFFAkX031473;
        Thu, 24 Feb 2022 16:16:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yqHL87504nAZ1oZxHURRiF32LNq/unDOPPKMbX8ZaNg=;
 b=A82d6JUGoq7dzu7Ouyd7z6wzw3RZTdYPgTq+RHsEijA+I+Ghi7VQag+8zB8J/AlLGeIL
 SmpprGlwnFebxyI0JBQyKEAI31onSC+Emccpgm2Jlr5XFLAfjTWRGGZIRL2xzig5lCW8
 KWGeCUjhAzFL2ExF2AZKbMxOXxTwuMbjwrzWGnB8C1H47iQh1aaRGWPfb3S9Uit7dD4+
 QZGqaHiptX2rvfheQbrkblGHKCbH7+voIyqqEqV75zlD/noyusLkwiWZFW5YUUf0kDLE
 dZEmCLzmdIEMcRcCY0INyuCbrZZYLjhkrLzyah/ZKKpdo31pE3850lNSJuLJD61K/vfT rQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edh6xpjam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 16:16:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OG77kF002898;
        Thu, 24 Feb 2022 16:16:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3eaqtk114t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 16:16:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OG6BV747317492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 16:06:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B382A4040;
        Thu, 24 Feb 2022 16:16:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77B29A4057;
        Thu, 24 Feb 2022 16:16:52 +0000 (GMT)
Received: from sig-9-65-86-89.ibm.com (unknown [9.65.86.89])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 16:16:52 +0000 (GMT)
Message-ID: <b89ec5792da3c284f8e5e058c5568482beccf00d.camel@linux.ibm.com>
Subject: Re: [PATCH v5 4/8] ima: define a new template field 'd-type' and a
 new template 'ima-ngv2'
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Feb 2022 11:16:51 -0500
In-Reply-To: <YhbSE/k4mElcehDN@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-5-zohar@linux.ibm.com>
         <YhbSE/k4mElcehDN@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: amlH_6L_r5yAerddFZgbRhMWxqrmxiS4
X-Proofpoint-ORIG-GUID: amlH_6L_r5yAerddFZgbRhMWxqrmxiS4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202240095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2022-02-23 at 16:32 -0800, Eric Biggers wrote:
> On Fri, Feb 11, 2022 at 04:43:06PM -0500, Mimi Zohar wrote:
> > In preparation to differentiate between regular IMA file hashes and
> > fs-verity's file digests, define a new template field named 'd-type'.
> > Define a new template named 'ima-ngv2', which includes the new 'd-type'
> > field.
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >  security/integrity/ima/ima_template.c     |  3 +++
> >  security/integrity/ima/ima_template_lib.c | 13 +++++++++++++
> >  security/integrity/ima/ima_template_lib.h |  2 ++
> >  3 files changed, 18 insertions(+)
> > 
> > diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> > index db1ad6d7a57f..b321342e5bee 100644
> > --- a/security/integrity/ima/ima_template.c
> > +++ b/security/integrity/ima/ima_template.c
> > @@ -19,6 +19,7 @@ enum header_fields { HDR_PCR, HDR_DIGEST, HDR_TEMPLATE_NAME,
> >  static struct ima_template_desc builtin_templates[] = {
> >  	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
> >  	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
> > +	{.name = "ima-ngv2", .fmt = "d-ng|n-ng|d-type"},
> >  	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
> >  	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
> >  	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
> > @@ -40,6 +41,8 @@ static const struct ima_template_field supported_fields[] = {
> >  	 .field_show = ima_show_template_digest_ng},
> >  	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
> >  	 .field_show = ima_show_template_string},
> > +	{.field_id = "d-type", .field_init = ima_eventdigest_type_init,
> > +	 .field_show = ima_show_template_string},
> >  	{.field_id = "sig", .field_init = ima_eventsig_init,
> >  	 .field_show = ima_show_template_sig},
> >  	{.field_id = "buf", .field_init = ima_eventbuf_init,
> 
> I notice that the "d-ng" field already contains both the hash algorithm and the
> hash itself, in the form <algorithm>:<hash>.  Wouldn't it make more sense to
> define a "d-ngv2" field that contains <type>:<algorithm>:<hash>?  After all,
> both the type and algorithm are required to interpret the hash.
> 
> Or in other words, what about the hash type is different from the hash algorithm
> that would result in them needing different handling here?

Thanks, Eric.  I really like your suggestion.  Currently, type is
defined as either "ima" or "verity".   Are you ok with prefixing each
record with these strings?

-- 
thanks,

Mimi

