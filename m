Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E94A466BF5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhLBWQq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:16:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229836AbhLBWQp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:16:45 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LmAQb026623;
        Thu, 2 Dec 2021 22:13:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=zOGjOBHtUL7i0toHSDOddiI1wEvrmQ1pSfztA7M85fk=;
 b=HprCaZ9pv9VxQsYdrdGZPcnpxbePv+IDTAwxpgFkE5ikT2YMwkDvFVmk1iyTiEEra7bO
 WFFvRuTctPAovaQ0KinskaVPHp8BbxH2EjgLBgwASPY5tk0LB9iU5Hci20Q1vO32J7BQ
 9omaI9HpKvg3/ZjZgmD3o6cNiAgnrDqugX+KTgi5rlBhKY++cOGuEcdFsilR09EzitK0
 stmY9HBRkAGcw1Nrp1j7xlrtuU+PFMQQJjv8Xc3MzJblT8fACXcTipvMINANArHrhRdP
 YZTziYY1macaBSvjZVAGEZnPF3hzWFhf2AID06Parw7MIENRKVeVcXsNT85Rcpl4ed6b cg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq6cd8qh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 22:13:20 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2M6KDJ024174;
        Thu, 2 Dec 2021 22:13:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ckcaans1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 22:13:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2MDGp616974120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 22:13:16 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C45811C04A;
        Thu,  2 Dec 2021 22:13:16 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AC5111C05B;
        Thu,  2 Dec 2021 22:13:15 +0000 (GMT)
Received: from sig-9-65-72-23.ibm.com (unknown [9.65.72.23])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Dec 2021 22:13:15 +0000 (GMT)
Message-ID: <4dc45d1ec7450b4d1d06b12baf73668525bd8157.camel@linux.ibm.com>
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Dec 2021 17:13:15 -0500
In-Reply-To: <YalDvGjq0inMFKln@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
         <20211202215507.298415-5-zohar@linux.ibm.com>
         <YalDvGjq0inMFKln@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GUf8TLev6hYp8FbMMl-j9fpCmTkv--dD
X-Proofpoint-GUID: GUf8TLev6hYp8FbMMl-j9fpCmTkv--dD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=761 clxscore=1015
 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 spamscore=0 phishscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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

The signature stored in security.ima is prefixed with a header
(signature_v2_hdr).

Mimi

