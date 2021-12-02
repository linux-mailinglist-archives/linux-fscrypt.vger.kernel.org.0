Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED624667FF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 17:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359537AbhLBQ3N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 11:29:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359490AbhLBQ25 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 11:28:57 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2GI24g027527;
        Thu, 2 Dec 2021 16:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=muvMSeyIIQwZPclPGBI9yNBS6axKv+emRwU19A4CBPY=;
 b=QGO0ZOti/mvhfejbPZHMiKyP2A06GDGHUB5EB8IKf8UFBwf9bNl4iLUoNHjBNo2Dm0M3
 dl0RTWeWWk8FL+8B+8VB1K+FHrYCRV7NbJDkzcXHEp44wlbwgndnDbZp9hm7i2sBQqYR
 j1EXUmQop70wA9NDbZ4Vr3aFjFF+HklU44QBaIRLKDh6JJfwzMh1cHUN3k8dfDARw5OD
 cfJMVqlW5OpndW7ZjCPiPkXpwI2j9xVrl4uqmJBRly+dw4c9SQCy2wqaG4xgxX5DQKhF
 3WLcU3mFohtWyOTwbVgQdvTDJs4S5xNoAkrWOndlYvhbhYOlmZDyZ8wFqOxQ0ozm5Y6K 0Q== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cq1hu84d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 16:25:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2GHw3J015148;
        Thu, 2 Dec 2021 16:25:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3ckcaabtn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 16:25:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2GPLEJ18612616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 16:25:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBAD811C05C;
        Thu,  2 Dec 2021 16:25:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C1811C058;
        Thu,  2 Dec 2021 16:25:20 +0000 (GMT)
Received: from sig-9-65-72-23.ibm.com (unknown [9.65.72.23])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 16:25:20 +0000 (GMT)
Message-ID: <a1b808d664603bfd4bd2f747b59c3e0c51646922.camel@linux.ibm.com>
Subject: Re: [PATCH 2/4] ima: define a new signature type named
 IMA_VERITY_DIGSIG
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Dec 2021 11:25:05 -0500
In-Reply-To: <6931ed7b1c7d5906bb595447fc24cd8a9b3e3d62.camel@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <20211129170057.243127-3-zohar@linux.ibm.com>
         <YaWNX3nwslG/Q2aH@sol.localdomain>
         <6931ed7b1c7d5906bb595447fc24cd8a9b3e3d62.camel@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MO0yun4aboIqngP3f1t1pOt2QCGpAo07
X-Proofpoint-ORIG-GUID: MO0yun4aboIqngP3f1t1pOt2QCGpAo07
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_10,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020106
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Tue, 2021-11-30 at 13:14 -0500, Mimi Zohar wrote:
> On Mon, 2021-11-29 at 18:33 -0800, Eric Biggers wrote:
> > On Mon, Nov 29, 2021 at 12:00:55PM -0500, Mimi Zohar wrote:
> > > To differentiate between a regular file hash and an fs-verity file digest
> > > based signature stored as security.ima xattr, define a new signature type
> > > named IMA_VERITY_DIGSIG.
> > > 
> > > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > 
> > For this new signature type, what bytes are actually signed?  It looks like it's
> > just the raw digest, which isn't sufficient since it is ambiguous.  It needs to
> > include information that makes it clear what the signer is actually signing,
> > such as "this is an fs-verity SHA-256 file digest".  See
> > 'struct fsverity_formatted_digest' for an example of this (but it isn't
> > necessary to use that exact structure).
> > 
> > I think the existing IMA signatures have the same problem (but it is hard for me
> > to understand the code).  However, a new signature type doesn't have
> > backwards-compatibility concerns, so it could be done right.
> 
> As this change should probably be applicable to all signature types,
> the signature version in the  signature_v2_hdr should be bumped.  The
> existing signature version could co-exist with the new signature
> version.

By signing the file hash, the sig field in the IMA measurement list can
be directly verified against the digest field.  For appended
signatures, we defined a new template named ima-modsig which contains
two file hashes, with and without the appended signature.

Similarly, by signing a digest containing other metadata and fs-
verity's file digest, the measurement list should include both digests.
Otherwise the consumer of the measurement list would first need to
calculate the signed digest before verifying the signature.

Options:
- Include just fs-verity's file digest and the signature in the
measurement list.  Leave it to the consumer of the measurement list to
deal with.
- Define a new template format to include both digests, add a new field
in the iint for the signed digest.  (Much more work.)
- As originally posted, directly sign fs-verity's file digest.

thanks,

Mimi

