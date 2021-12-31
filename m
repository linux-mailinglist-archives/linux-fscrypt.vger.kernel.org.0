Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437C1482491
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Dec 2021 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhLaPfJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Dec 2021 10:35:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhLaPfI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Dec 2021 10:35:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BVCGicK015277;
        Fri, 31 Dec 2021 15:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LP/dBwlqnNk/jLLOaJ7zpEi8bzPx+FAQeQ4w/ORZh+4=;
 b=nRvd2Isrehz5K8MDuHskgKA+a9KSVAV0R3Un31cw1JbL88w7M6iMwtf/FBn+NVcWIHrO
 4+szHJvuCuli5frfRwly5FHHI5CEblPb3/FNi/FuoLZUnN7LLtXhj3ft173hcTn3+OBL
 l/ORSHEkT5d81tRpmGtUtWhSK5CGmR/AdMF1WnUX6GjvCqBvmcAnlLcH31a4oPa0/UcW
 GFETGCekaYFHJuB+RK+ClIHqcflD7/1Eyd6bF6gML0dt0PQ/JRim24Ed6Uqq2r4b6s8P
 7OB2DbbBMrFUFM8w2YHh58RCNtCAKzjz1Sf7BMRfNtG8lGP1Ue3fSfWQZLmRl5Sf330p yw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d9qyvm17c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Dec 2021 15:35:06 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BVF7JpL031036;
        Fri, 31 Dec 2021 15:35:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3d5tjk1dbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Dec 2021 15:35:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BVFZ1MT37814750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Dec 2021 15:35:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E87752054;
        Fri, 31 Dec 2021 15:35:01 +0000 (GMT)
Received: from sig-9-65-77-101.ibm.com (unknown [9.65.77.101])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ECD7C52051;
        Fri, 31 Dec 2021 15:35:00 +0000 (GMT)
Message-ID: <56c53b027ae8ae6909d38904bf089e73011657d7.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 31 Dec 2021 10:35:00 -0500
In-Reply-To: <YalDvGjq0inMFKln@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
         <20211202215507.298415-5-zohar@linux.ibm.com>
         <YalDvGjq0inMFKln@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1H1ZfXi8nX8DwlQxOYJYVOme3-KcPwe8
X-Proofpoint-ORIG-GUID: 1H1ZfXi8nX8DwlQxOYJYVOme3-KcPwe8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-31_06,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 mlxlogscore=975 spamscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112310067
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Thu, 2021-12-02 at 14:07 -0800, Eric Biggers wrote:
> On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
> >  	case IMA_VERITY_DIGSIG:
> > -		fallthrough;
> > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > +
> > +		/*
> > +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> > +		 * and the fs-verity file digest, not directly on the
> > +		 * fs-verity file digest.  Both digests should probably be
> > +		 * included in the IMA measurement list, but for now this
> > +		 * digest is only used for verifying the IMA signature.
> > +		 */
> > +		verity_digest[0] = IMA_VERITY_DIGSIG;
> > +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> > +		       iint->ima_hash->length);
> > +
> > +		hash.hdr.algo = iint->ima_hash->algo;
> > +		hash.hdr.length = iint->ima_hash->length;
> 
> This is still wrong because the bytes being signed don't include the hash
> algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
> supports SHA-512 too, and it may support other hash algorithms in the future.

IMA assumes that the file hash algorithm and the signature algorithm
are the same.   If they're not the same, for whatever reason, the
signature verification would simply fail.

Based on the v2 signature header 'type' field, IMA can differentiate
between regular IMA file hash based signatures and fs-verity file
digest based signatures.  The digest field (d-ng) in the IMA
meausrement list prefixes the digest with the hash algorithm. I'm
missing the reason for needing to hash fs-verity's file digest with
other metadata, and sign that hash rather than fs-verity's file digest
directly.

thanks,

Mimi

