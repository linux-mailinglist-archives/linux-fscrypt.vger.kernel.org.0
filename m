Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25A2466BD8
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377180AbhLBV7l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349151AbhLBV7k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:40 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LHfdB006241;
        Thu, 2 Dec 2021 21:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ZUetK5gb7PtksRJ6FYhDe+/VGOeiT4gHZX0fzcz96QA=;
 b=JE08HSQeJKp2dp2p1aJO7mBSB6SbizyhtxTGmjiFF4cEHcAf9uBk9uVPa2ABVmgST7x7
 7pC/G32Ynn6exxWLzgXG0QJX7ImJ7KWIURaXgvkKs6qOku1bqgaH8yHMcC9/5gQED3w7
 MpcxaHvd+hqCcG/6A2I8HByI81CxGtp/KfQT5bbJ/V7+JGzevPY1mBDMTeX4fTNcvlWL
 ctQTyr2Bd4sNDxUBtCllQqv3oXeaPD0pRAEspCRPYB+eL7R1X7Pau85oXjuXCOYxC8MU
 scCFgxMkjJQDtUFJsWEh9xyvW7/kQl0zcsH/G1jsIm0KYYUJ5B+hczEIgpbTnUCIFAwo qg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq5xcs1bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:56:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LoEsb008840;
        Thu, 2 Dec 2021 21:56:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkrb7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:56:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2LuBc328967328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:56:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A0F04C04E;
        Thu,  2 Dec 2021 21:56:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4BF94C040;
        Thu,  2 Dec 2021 21:56:10 +0000 (GMT)
Received: from sig-9-65-72-23.ibm.com (unknown [9.65.72.23])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 21:56:10 +0000 (GMT)
Message-ID: <5505f37bb0198da914bee965b22fa7246a079c0d.camel@linux.ibm.com>
Subject: Re: [PATCH 2/4] ima: define a new signature type named
 IMA_VERITY_DIGSIG
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Dec 2021 16:56:10 -0500
In-Reply-To: <Yak3+n7fcqaM53ct@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <20211129170057.243127-3-zohar@linux.ibm.com>
         <YaWNX3nwslG/Q2aH@sol.localdomain>
         <6931ed7b1c7d5906bb595447fc24cd8a9b3e3d62.camel@linux.ibm.com>
         <a1b808d664603bfd4bd2f747b59c3e0c51646922.camel@linux.ibm.com>
         <Yak3+n7fcqaM53ct@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uGPEgjdRaAVKnOFc7exeROjHFVYzzPyW
X-Proofpoint-GUID: uGPEgjdRaAVKnOFc7exeROjHFVYzzPyW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2021-12-02 at 13:17 -0800, Eric Biggers wrote:
> On Thu, Dec 02, 2021 at 11:25:05AM -0500, Mimi Zohar wrote:
> > Hi Eric,
> > 
> > On Tue, 2021-11-30 at 13:14 -0500, Mimi Zohar wrote:
> > > On Mon, 2021-11-29 at 18:33 -0800, Eric Biggers wrote:
> > > > On Mon, Nov 29, 2021 at 12:00:55PM -0500, Mimi Zohar wrote:
> > > > > To differentiate between a regular file hash and an fs-verity file digest
> > > > > based signature stored as security.ima xattr, define a new signature type
> > > > > named IMA_VERITY_DIGSIG.
> > > > > 
> > > > > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > > > 
> > > > For this new signature type, what bytes are actually signed?  It looks like it's
> > > > just the raw digest, which isn't sufficient since it is ambiguous.  It needs to
> > > > include information that makes it clear what the signer is actually signing,
> > > > such as "this is an fs-verity SHA-256 file digest".  See
> > > > 'struct fsverity_formatted_digest' for an example of this (but it isn't
> > > > necessary to use that exact structure).
> > > > 
> > > > I think the existing IMA signatures have the same problem (but it is hard for me
> > > > to understand the code).  However, a new signature type doesn't have
> > > > backwards-compatibility concerns, so it could be done right.
> > > 
> > > As this change should probably be applicable to all signature types,
> > > the signature version in the  signature_v2_hdr should be bumped.  The
> > > existing signature version could co-exist with the new signature
> > > version.
> > 
> > By signing the file hash, the sig field in the IMA measurement list can
> > be directly verified against the digest field.  For appended
> > signatures, we defined a new template named ima-modsig which contains
> > two file hashes, with and without the appended signature.
> > 
> > Similarly, by signing a digest containing other metadata and fs-
> > verity's file digest, the measurement list should include both digests.
> > Otherwise the consumer of the measurement list would first need to
> > calculate the signed digest before verifying the signature.
> > 
> > Options:
> > - Include just fs-verity's file digest and the signature in the
> > measurement list.  Leave it to the consumer of the measurement list to
> > deal with.
> > - Define a new template format to include both digests, add a new field
> > in the iint for the signed digest.  (Much more work.)
> > - As originally posted, directly sign fs-verity's file digest.
> 
> I don't really have enough knowledge about IMA and how it is used to decide on
> one approach or the other.  Note that earlier I mentioned that it would be
> possible to have an fs-verity setting that makes a full file digest be included
> in the fsverity_descriptor, so it gets covered by the fs-verity file digest and
> is also retrievable in constant time like the fs-verity file digest is.
> 
> If you'd like to solve this problem at the IMA layer instead, by storing the
> full file digest in an xattr and signing both the full file digest and fs-verity
> file digest together, that would achieve the same goal of making the full file
> digest available, and wouldn't require any changes to fs-verity.  This would
> assume that the file would be signed, though.  What about audit-only mode
> without signatures; is that something you care about?
> 
> Alternatively, maybe this problem doesn't need to be solved at all and IMA would
> be fine with the fs-verity file digest only, and not need the full file hash
> too.  I don't know the answer to that; I think it's up to you to decide.

I just posted v1 which implements option 1, including the fsverity file
digest in
the measurement list.  Both option 2 or including the actual file hash,
will require a new template format with two digests.

Mimi

