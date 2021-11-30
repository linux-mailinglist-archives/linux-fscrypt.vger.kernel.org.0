Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE1B463596
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhK3NkL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 08:40:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhK3NkK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 08:40:10 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUDHOmp003917;
        Tue, 30 Nov 2021 13:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=qyOEgt+j8v4rot0tCjopd92DtEHy28X+Qjah5atxKE0=;
 b=ZTaRGoGRjtzvqGblV3xeWyfNB2Pveas7xqyEKACcROWo9TzJNgUoJeF4GqZY/wPV7m8G
 G6QDcf+wKXQZPZnSgx4siULAkAl3TclwWlceNpokYoH8kX0B/nkkk3IP15Vf7Od/qLot
 c/pluHAMdxQF/j4VaG60cg2UMmeiDPzi/5aeCpLuQzJnDLgXXaMfUA71ZqnaCiMjAvIp
 DNwA2Gu6EmHdl+IJFbV9b4XFNYe+UkiTznYwOXQxBuZiXgVWFtDrRvryaK1Mni60yoHo
 jVaLoXlvS2beuSGvTrRxqo4l/zc3oVi4C2lGIICdzsshfoZ10sO8C0LVlnlOO+nCYurj 6g== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnmq88d3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 13:36:49 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AUDWeg0017485;
        Tue, 30 Nov 2021 13:36:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ckca9wtes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 13:36:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AUDai1S27984382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 13:36:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D76552098;
        Tue, 30 Nov 2021 13:36:44 +0000 (GMT)
Received: from sig-9-65-92-250.ibm.com (unknown [9.65.92.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 85C1952093;
        Tue, 30 Nov 2021 13:36:42 +0000 (GMT)
Message-ID: <138c2aa0dba46d5e6bb163ca8bb62b4117cc8459.camel@linux.ibm.com>
Subject: Re: [PATCH 4/4] ima: support fs-verity file digest based signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Date:   Tue, 30 Nov 2021 08:36:41 -0500
In-Reply-To: <7dfa283e-13b2-40de-158d-8642778d74cc@linux.microsoft.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
         <20211129170057.243127-5-zohar@linux.ibm.com>
         <7dfa283e-13b2-40de-158d-8642778d74cc@linux.microsoft.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uBM_6rOdkwnp30mb3N8Al8z1WBT7Nvay
X-Proofpoint-GUID: uBM_6rOdkwnp30mb3N8Al8z1WBT7Nvay
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_08,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111300078
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Lakshmi, Eric,

On Mon, 2021-11-29 at 21:56 -0800, Lakshmi Ramasubramanian wrote:
> Hi Mimi,
> 
> On 11/29/2021 9:00 AM, Mimi Zohar wrote:
> > Instead of calculating a file hash and verifying the signature stored
> > in the security.ima xattr against the calculated file hash, verify the
> > signature of the fs-verity's file digest.  The fs-verity file digest is
> > a hash that includes the Merkle tree root hash.

> This patch is reading the fs-verity signature for the given file using 
> the new function fsverity_measure() that was defined in [Patch 1/4]. Is 
> it also verifying the fs-verity signature here?

Yes, the signature stored in the security.ima xattr may be a file hash,
a regular file signature, or a signature of the fs-verity file digest. 
The signature is verified like any other signature stored as an xattr.

>  
> > +static int ima_collect_verity_measurement(struct integrity_iint_cache *iint,
> > +					  struct ima_digest_data *hash)
> > +{
> > +	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
> > +	enum hash_algo verity_alg;
> > +	int rc;
> > +
> > +	rc = fsverity_measure(iint->inode, verity_digest, &verity_alg);
> nit: fsverity_collect_measurement() may be more appropriate for this 
> function (defined in [PATCH 1/4]).

From an IMA perspective it certainly would be a better function name,
but this function may be used by other kernel subsystems.  Eric
suggested renaming the function as fsverity_get_digest(), as opposed to
fsverity_read_digest().   get/put are normally used to bump a reference
count or to get/release a lock.   Perhaps a combination like
fsverity_collect_digest() would be acceptable.

thanks,

Mimi

