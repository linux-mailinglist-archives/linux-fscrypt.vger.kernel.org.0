Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF2548985E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 13:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245327AbiAJMO6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jan 2022 07:14:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245358AbiAJMNv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jan 2022 07:13:51 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AC8hCG028776;
        Mon, 10 Jan 2022 12:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Xak/CKLMnioeGOSndHD6lQ+kfo22g2B8NuO2kHa7z0E=;
 b=TmqMf5H6DVJ8wH7eTGzr6aWgdMp+Aa6moKzaVc28L9S385jSv7u7b3ngf90du0mNw+vM
 iTlhJvZ08BXo8d7Oz/PgsOgUihkujeRXVLvpb54RBIKHnYDhJZZfC5i5ja3j9mWeUDOx
 p0dv9+yLp9J5CR9ccZjz/W9/HVdoxlYR/SEvg4H338ho+p9gv5FAt4W1dU+nKzOjjEMV
 QKHN+p2KZGEBsLnN7hd1B4pY71DtNC16YaOzUIkU/Tami+kAlOMxe4Tw2X2bQWEnRz97
 fijKKPFpFhiJMcF72mSOsREdxPM/S3ZIf9xvqpFK1EifnRrm0mP8uqG8oMLa3fiwsm+b Sw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3df37wv2yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:13:42 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ACDR7p032182;
        Mon, 10 Jan 2022 12:13:41 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3df288ukb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:13:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ACDO5v43843854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 12:13:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09CBA405E;
        Mon, 10 Jan 2022 12:13:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41957A4055;
        Mon, 10 Jan 2022 12:13:23 +0000 (GMT)
Received: from sig-9-65-93-173.ibm.com (unknown [9.65.93.173])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 12:13:23 +0000 (GMT)
Message-ID: <6361f769a41d319810f33c559f52938cf93607bb.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/6] fs-verity: define a function to return the
 integrity protected file digest
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-integrity@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 10 Jan 2022 07:13:22 -0500
In-Reply-To: <20220110004738.kzhzyastvq5rn2g5@altlinux.org>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
         <20220109185517.312280-3-zohar@linux.ibm.com>
         <20220110004738.kzhzyastvq5rn2g5@altlinux.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8t7hD3g3bgukSVN8lyjGERRfOlEohop0
X-Proofpoint-ORIG-GUID: 8t7hD3g3bgukSVN8lyjGERRfOlEohop0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_05,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 mlxscore=0 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100085
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Vitaly,

On Mon, 2022-01-10 at 03:47 +0300, Vitaly Chikunov wrote:
> Mimi,
> 
> On Sun, Jan 09, 2022 at 01:55:13PM -0500, Mimi Zohar wrote:
> > Define a function named fsverity_get_digest() to return the verity file
> > digest and the associated hash algorithm (enum hash_algo).
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >  fs/verity/Kconfig            |  1 +
> >  fs/verity/fsverity_private.h |  7 -------
> >  fs/verity/measure.c          | 40 ++++++++++++++++++++++++++++++++++++
> >  include/linux/fsverity.h     | 18 ++++++++++++++++
> >  4 files changed, 59 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/verity/measure.c b/fs/verity/measure.c
> > index f0d7b30c62db..52906b2e5811 100644
> > --- a/fs/verity/measure.c
> > +++ b/fs/verity/measure.c
> > @@ -57,3 +57,43 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
> > +
> > +/**
> > + * fsverity_get_digest() - get a verity file's digest
> > + * @inode: inode to get digest of
> > + * @digest: (out) pointer to the digest
> > + * @alg: (out) pointer to the hash algorithm enumeration
> > + *
> > + * Return the file hash algorithm and digest of an fsverity protected file.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_get_digest(struct inode *inode,
> > +			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> > +			    enum hash_algo *alg)
> > +{
> > +	const struct fsverity_info *vi;
> > +	const struct fsverity_hash_alg *hash_alg;
> > +	int i;
> > +
> > +	vi = fsverity_get_info(inode);
> > +	if (!vi)
> > +		return -ENODATA; /* not a verity file */
> > +
> > +	hash_alg = vi->tree_params.hash_alg;
> > +	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
> > +	*alg = HASH_ALGO__LAST;
> 
> Perhaps this line is redundant (*alg is overwritten later) and would
> needlessly mangle output value in case of -EINVAL while it's being
> untouched on -ENODATA.
> 

Thanks!

Mimi

> 
> > +
> > +	/* convert hash algorithm to hash_algo_name */
> > +	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
> > +	if (i < 0)
> > +		return -EINVAL;
> > +	*alg = i;
> > +
> > +	memcpy(digest, vi->file_digest, hash_alg->digest_size);
> > +
> > +	pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
> > +		  hash_digest_size[*alg], digest);
> > +
> > +	return 0;
> > +}


