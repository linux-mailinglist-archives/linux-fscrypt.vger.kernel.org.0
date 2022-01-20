Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D320495281
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jan 2022 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243712AbiATQkL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jan 2022 11:40:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12316 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243030AbiATQkJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jan 2022 11:40:09 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KGF9N8026896;
        Thu, 20 Jan 2022 16:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=+1n7Fi25DBUOMI0Zb/z6ZedRuN25KlbopUMoutGPpBs=;
 b=PuydMwoJS9xlHDrkgvvaHRdpE8gxizmrPs8otb+Bs4F1sLgTwUeH3sHKIp351YBzkIVw
 Wg/V2schN3R9Im0km/JfvBuyUGPidb/FfCilm6qYE7FCxTtfncOon9/GykscS0TDvBcj
 6MaZNHgn1dFQbB2xlJaC7x0ysnTBBDh5nJ2ZOoLbPC1H0ZGau7a6Os8WRp5BOcnOB7WG
 d8i3/m5sQ/VGMv9P7BO10gcosuPRRlTCkA9OogBNtlP2pqdldllodBnVA4rMM5j2+iNj
 J6j7r+B35vgT38MaaKMdcZyAmGxpahWewLaJnH7TMAwivsSFBRismBJ6xpRaMSYbAM6g lQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq6vs7apt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 16:40:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20KGJq5h026390;
        Thu, 20 Jan 2022 16:40:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhk3hem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 16:40:00 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20KGdwQi43123192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:39:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D6FD11C04C;
        Thu, 20 Jan 2022 16:39:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56C3811C05B;
        Thu, 20 Jan 2022 16:39:57 +0000 (GMT)
Received: from sig-9-65-73-24.ibm.com (unknown [9.65.73.24])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 16:39:57 +0000 (GMT)
Message-ID: <c0676336a7992b6495c5f5dec7ca1897fb4005eb.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 20 Jan 2022 11:39:56 -0500
In-Reply-To: <Yedd0CKCHSq1ugFk@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
         <20211202215507.298415-5-zohar@linux.ibm.com>
         <YalDvGjq0inMFKln@sol.localdomain>
         <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
         <YdYrw4eiQPryOMkZ@gmail.com> <20220109204537.oueokvvkrkyy3ipq@altlinux.org>
         <YdtOhsv/A5dqlApY@sol.localdomain>
         <20220115053101.36xoy2bc7ypozo6l@altlinux.org>
         <YeJn7hxLEfdVrUQT@sol.localdomain>
         <bc803a35d914dde65640428d2b29cc6e89d176d4.camel@linux.ibm.com>
         <Yedd0CKCHSq1ugFk@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vaUPOoqq10PgPMtBSoNMEAgtgw4uLfxC
X-Proofpoint-ORIG-GUID: vaUPOoqq10PgPMtBSoNMEAgtgw4uLfxC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_06,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201200084
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric, Vitaly,

On Tue, 2022-01-18 at 16:39 -0800, Eric Biggers wrote:

> > > The easiest way to do this would be sign/verify the following struct:
> > > 	struct ima_file_id {
> > > 		u8 is_fsverity;
> > > 		u8 hash_algorithm;
> > > 		u8 hash[];
> > > 	};


> > This would be the *data* that is signed/verified -- meaning that it
would be
> > > hashed again as part of the signature algorithm (whether that hash is built-in
> > > to the signature algorithm, as is the case for modern algorithms, or handled by
> > > the caller as is the case for legacy algorithms).
> > 
> > There seems to be an inconsistency, here, with what you said above,
> > "... ECDSA just signs/verifies a raw hash, and in fact it *must* be a
> > raw hash for it to be secure."
> 
> There isn't an inconsistency.  ECDSA is among the algorithms where the caller is
> expected to handle the hash.
> 
> It is confusing dealing with all these different signature algorithms.  I think
> the right way to think about this is in terms of what *data* is being
> signed/verified.  Currently the data is the full file contents.  I think it
> needs to be made into an annotated hash, e.g. the struct I gave.
> 
> public_key_verify_signature() also needs to be fixed to support both types of
> signature algorithms (caller-provided hash and internal hash) in a logical way.
> Originally it only supported caller-provided hashes, but then SM2 support was
> added and now it is super broken.

Eric, did you say you're working on fixes to address these problems?

> 
> > > Note that both traditional
> > > and fs-verity hashes would need to use this same method for it to be secure; the
> > > kernel must not accept signatures using the old method at the same time.
> > 
> > The v2 version of this patch set signed the hash of a hash just for fs-
> > verity signatures.  Adding the equivalent support for regular file
> > hashes will require the version in the IMA signature_v2_hdr to be
> > incremented.  If the version is incremented now, both signatures
> > versions should then be able to co-exist.
> 
> That seems like a good thing, unless you want users to be responsible for only
> ever signing full file hashes *or* fs-verity file hashes with each key.  That
> seems like something that users will get wrong.

Instead of using a flexible array, Vitaly suggested defining the hash
as FS_VERITY_MAX_DIGEST_SIZE, so that it could be allocated temporarily
on stack
instead of kalloc.

As the above struct is not limited to fsverity, we could use
MAX_HASH_DIGESTSIZE, if it was exported, but it isn't.  Would the
following work for you?

/*
 * IMA signature header version 3 disambiguates the data that is signed
by
 * indirectly signing the hash of this structure, containing either the
 * fsverity_descriptor struct digest or, in the future, the traditional
IMA
 * file hash.
 */
struct ima_file_id {
        __u8 is_fsverity;       /* set to 1 for IMA_VERITY_DIGSIG */
        __u8 hash_algorithm;    /* Digest algorithm [enum hash_algo] */
#ifdef __KERNEL__
        __u8 hash[HASH_MAX_DIGESTSIZE];
#else
        __u8 hash[];
#endif
};

thanks,

Mimi

