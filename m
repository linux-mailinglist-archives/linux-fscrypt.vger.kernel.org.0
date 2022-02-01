Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6354A61D2
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 18:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiBARDX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Feb 2022 12:03:23 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241354AbiBARDW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Feb 2022 12:03:22 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211EcbE5023486;
        Tue, 1 Feb 2022 17:03:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7jOF3oJAsyVkVlHQcrq5VZ83DvUv+afgF4joD2GsMNA=;
 b=O5lHmYFTW2e8IyUoPCrfolv/5/GCp7M2a6lVW9LFcGE0RRJW0SqugaaDlnJn0lQ0mZ3l
 eIwolerf5fGNQp/EPqrz/1TsObTnpU+btYr1aE0ySBWgSjtlkQHlSdF6QyoEcADhgbfa
 nGn+1Ck235wOjVJhRgPGqgxOS90qZQ0mk/aUWcBASlxk+HRQqEqB7gbxyX4PDGXZ6q2J
 Nnyl0vDm1kcdO8h9Gz7v+ShxjlToGkfACwKoa5wVi1M+LhEehdNizUDMYMEro+7OCmso
 /8CxIlpy6Ot7bGHsG4kX3zRdXlrhTfUGjB/rnuPLRr2HhdMSU0KqBZrhU8bi9fH7iIfI DQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dxvkk6wns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 17:03:21 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211GmkQ9000472;
        Tue, 1 Feb 2022 17:03:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3dvw79pkxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Feb 2022 17:03:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211H3GNi31981952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Feb 2022 17:03:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84E77A4054;
        Tue,  1 Feb 2022 17:03:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91681A405F;
        Tue,  1 Feb 2022 17:03:15 +0000 (GMT)
Received: from sig-9-65-72-103.ibm.com (unknown [9.65.72.103])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Feb 2022 17:03:15 +0000 (GMT)
Message-ID: <51d294703f69ab05252c85437be668e25bab08f3.camel@linux.ibm.com>
Subject: Re: [PATCH v3 7/8] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 01 Feb 2022 12:03:14 -0500
In-Reply-To: <YfiHrMU5tOsg5DMi@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
         <20220126000658.138345-8-zohar@linux.ibm.com>
         <YfiHrMU5tOsg5DMi@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lCgScqy4fTDLDFsniwuImqElnm4JAUd4
X-Proofpoint-ORIG-GUID: lCgScqy4fTDLDFsniwuImqElnm4JAUd4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_08,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010095
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-01-31 at 17:06 -0800, Eric Biggers wrote:
> On Tue, Jan 25, 2022 at 07:06:57PM -0500, Mimi Zohar wrote:
> > Instead of calculating a file hash and verifying the signature stored
> > in the security.ima xattr against the calculated file hash, verify
> > fs-verity's signature (version 3).
> > 
> > To differentiate between a regular file hash and an fs-verity file digest
> > based signature stored as security.ima xattr, define a new signature type
> > named IMA_VERITY_DIGSIG.
> > 
> > Update the 'ima-sig' template field to display the new fs-verity signature
> > type as well.
> > 
> > For example:
> >   appraise func=BPRM_CHECK digest_type=hash|verity
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >  Documentation/ABI/testing/ima_policy      | 10 +++++
> >  Documentation/security/IMA-templates.rst  |  4 +-
> >  security/integrity/ima/ima_appraise.c     | 49 ++++++++++++++++++++++-
> >  security/integrity/ima/ima_template_lib.c |  3 +-
> >  security/integrity/integrity.h            |  5 ++-
> >  5 files changed, 65 insertions(+), 6 deletions(-)
> 
> All this IMA-specific stuff is confusing to me, so let me ask a question about
> what the end result actually is.  Let's say I want to use IMA to authenticate
> ("appraise") a file.  I've signed its fs-verity digest with a key.  I put only
> that one key in the IMA keyring, and that key was only ever used to sign that
> one fs-verity digest.  Can an attacker (who controls the file's contents and IMA
> xattr) replace the file with one with a different contents and still pass the
> IMA check?  For example, could they replace the file's contents with the
> ima_file_id of the authentic file, and then downgrade the signature version to
> v2?  If they can do that, then the goal of authentication wasn't met.  It might
> be necessary to enforce that only one signature version is used at a time, to
> avoid this kind of ambiguity.

Instead of only allowing a single signature version, the signature
verification could be based on policy rules.   "ima: include fsverity's
file digests in the IMA measurement list" defines the new policy rule
'digest_type=' option, which currently permits either IMA or fsverity
signatures to match.  Instead only allow IMA or fsverity signatures,
not both, on a per policy rule basis.

From an IMA perspective, this would be safe since the builtin policies
do not support fs-verity signatures.  After loading a custom policy,
additional rules can only extend the custom policy.

thanks,

Mimi

