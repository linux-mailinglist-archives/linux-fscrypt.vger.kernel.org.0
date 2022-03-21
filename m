Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5CE4E26FF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiCUM5C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 08:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238985AbiCUM5B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 08:57:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74112DE91E;
        Mon, 21 Mar 2022 05:55:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LA8rcA012413;
        Mon, 21 Mar 2022 12:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=i9FSWZOUmFDSxdmussmd7Hti/4DTWyRGI8gRhtar5Ew=;
 b=kDoBA7EYk1fT6q522pXIa1XuVDrkzEeOcoVsclxiufUoL8ng+xgafz/CCHFQsfmefeA4
 ZVWyJXkkdeqKY8cE2uV7ekLpvUwuuEl/RPtMaY2F/JZ2HtEoU2rWNGw40SEh44ZIckzW
 JmffHgymVyqTGqKwVy0TnDx7Z+cdKLi2CXOmH+Lp7euCJcyft/ipbyJpF+vmUMRAhjo1
 UnabVHVDGLOFS7zwLO8vZKOU4EjqhDAC9BN/esoJljrNywx8LDOqzHAHN0VKZlwVV065
 iAH9toln55mmK1SmBrPCOLASZI8LSixhWhAU6h7xS3nYx0ixjhOXyA8n13KF5zw4gILf MQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exmaq7b5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 12:55:34 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LCnfUv019916;
        Mon, 21 Mar 2022 12:55:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ehuddv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 12:55:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LCtTYR52756888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 12:55:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 766D742042;
        Mon, 21 Mar 2022 12:55:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CD644203F;
        Mon, 21 Mar 2022 12:55:28 +0000 (GMT)
Received: from sig-9-65-76-147.ibm.com (unknown [9.65.76.147])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 12:55:28 +0000 (GMT)
Message-ID: <493d1cd4393530276182a92a95d21367f03d4eaf.camel@linux.ibm.com>
Subject: Re: [PATCH v6 5/5] fsverity: update the documentation
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 21 Mar 2022 08:55:27 -0400
In-Reply-To: <e4af1e00-8eaa-259b-ad81-ec86682ea4af@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
         <20220318182151.100847-6-zohar@linux.ibm.com>
         <e4af1e00-8eaa-259b-ad81-ec86682ea4af@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Qm84yJr_eTY1ieE7oyOw5SJOCbwVPXIJ
X-Proofpoint-GUID: Qm84yJr_eTY1ieE7oyOw5SJOCbwVPXIJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_05,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2022-03-18 at 16:55 -0400, Stefan Berger wrote:
> 
> On 3/18/22 14:21, Mimi Zohar wrote:
> > Update the fsverity documentation related to IMA signature support.
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >   Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
> >   1 file changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> > index 1d831e3cbcb3..28a47488848e 100644
> > --- a/Documentation/filesystems/fsverity.rst
> > +++ b/Documentation/filesystems/fsverity.rst
> > @@ -74,8 +74,12 @@ authenticating the files is up to userspace.  However, to meet some
> >   users' needs, fs-verity optionally supports a simple signature
> >   verification mechanism where users can configure the kernel to require
> >   that all fs-verity files be signed by a key loaded into a keyring; see
> > -`Built-in signature verification`_.  Support for fs-verity file hashes
> > -in IMA (Integrity Measurement Architecture) policies is also planned.
> > +`Built-in signature verification`_.
> > +
> > +IMA supports including fs-verity file digests and signatures in the
> > +IMA (Integrity Measurement Architecture) measurement list and
> 
> The Integrity Measurement Architecture (IMA) supports including ...
> 
> > +verifying fs-verity based file signatures stored as security.ima
> > +xattrs, based on policy.
> >   
> >   User API
> >   ========
> > @@ -653,13 +657,13 @@ weren't already directly answered in other parts of this document.
> >       hashed and what to do with those hashes, such as log them,
> >       authenticate them, or add them to a measurement list.
> >   
> > -    IMA is planned to support the fs-verity hashing mechanism as an
> > -    alternative to doing full file hashes, for people who want the
> > -    performance and security benefits of the Merkle tree based hash.
> > -    But it doesn't make sense to force all uses of fs-verity to be
> > -    through IMA.  As a standalone filesystem feature, fs-verity
> > -    already meets many users' needs, and it's testable like other
> > -    filesystem features e.g. with xfstests.
> > +    IMA supports the fs-verity hashing mechanism as an alternative
> > +    to doing full file hashes, for people who want the performance
> 
> IMA supports the fs-verity hashing mechanism as an alternative to full 
> file hashes for those who want the performance and security benefits ...
> 
> > +    and security benefits of the Merkle tree based hash.  But it
> > +    doesn't make sense to force all uses of fs-verity to be through
> 
> However, it doesn't make sense ...
> 
> > +    IMA.  As a standalone filesystem feature, fs-verity already meets
> > +    many users' needs, and it's testable like other filesystem
> > +    features e.g. with xfstests.
> 
> Fs-verity already meets many user' needs even as a standalone filesystem 
> feature and it is testable like other ...
> 
> >   
> >   :Q: Isn't fs-verity useless because the attacker can just modify the
> >       hashes in the Merkle tree, which is stored on-disk?

Thanks, Stefan, for the suggestions.  I tried to minimize the changes
as much as possible.  Based on another thread, the documentation should
be updated, but I'm not going to be presumptuous and make those
changes.  Eric, should I drop this patch and let you update the fs-
verity documentation as you want?

-- 
thanks,

Mimi


