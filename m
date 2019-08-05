Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CCB815B4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Aug 2019 11:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbfHEJlq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Aug 2019 05:41:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbfHEJlo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Aug 2019 05:41:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x759MU7k053499
        for <linux-fscrypt@vger.kernel.org>; Mon, 5 Aug 2019 05:41:43 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u6gvqb7rp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Mon, 05 Aug 2019 05:41:43 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-fscrypt@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 5 Aug 2019 10:31:25 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 5 Aug 2019 10:31:22 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x759VLEr31457780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Aug 2019 09:31:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0F794203F;
        Mon,  5 Aug 2019 09:31:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3834F42047;
        Mon,  5 Aug 2019 09:31:21 +0000 (GMT)
Received: from dhcp-9-109-213-20.localnet (unknown [9.109.213.20])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Aug 2019 09:31:21 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: remove loadable module related code
Date:   Mon, 05 Aug 2019 15:02:56 +0530
Organization: IBM
In-Reply-To: <20190724194438.39975-1-ebiggers@kernel.org>
References: <20190724194438.39975-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19080509-4275-0000-0000-000003548B41
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080509-4276-0000-0000-0000386583C0
Message-Id: <1811491.Gh0OMl2qK5@dhcp-9-109-213-20>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=30 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050108
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thursday, July 25, 2019 1:14:38 AM IST Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since commit 643fa9612bf1 ("fscrypt: remove filesystem specific build
> config option"), fs/crypto/ can no longer be built as a loadable module.
> Thus it no longer needs a module_exit function, nor a MODULE_LICENSE.
> So remove them, and change module_init to late_initcall.
>

Looks good to me,

Reviewed-by: Chandan Rajendra <chandan@linux.ibm.com>

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/crypto.c          | 20 +-------------------
>  fs/crypto/fscrypt_private.h |  2 --
>  fs/crypto/keyinfo.c         |  5 -----
>  3 files changed, 1 insertion(+), 26 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 45c3d0427fb253..d52c788b723d01 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -510,22 +510,4 @@ static int __init fscrypt_init(void)
>  fail:
>  	return -ENOMEM;
>  }
> -module_init(fscrypt_init)
> -
> -/**
> - * fscrypt_exit() - Shutdown the fs encryption system
> - */
> -static void __exit fscrypt_exit(void)
> -{
> -	fscrypt_destroy();
> -
> -	if (fscrypt_read_workqueue)
> -		destroy_workqueue(fscrypt_read_workqueue);
> -	kmem_cache_destroy(fscrypt_ctx_cachep);
> -	kmem_cache_destroy(fscrypt_info_cachep);
> -
> -	fscrypt_essiv_cleanup();
> -}
> -module_exit(fscrypt_exit);
> -
> -MODULE_LICENSE("GPL");
> +late_initcall(fscrypt_init)
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 8978eec9d766dd..224178294371a4 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -166,6 +166,4 @@ struct fscrypt_mode {
>  	bool needs_essiv;
>  };
>  
> -extern void __exit fscrypt_essiv_cleanup(void);
> -
>  #endif /* _FSCRYPT_PRIVATE_H */
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index 207ebed918c159..9bcadc09e2aded 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -437,11 +437,6 @@ static int init_essiv_generator(struct fscrypt_info *ci, const u8 *raw_key,
>  	return err;
>  }
>  
> -void __exit fscrypt_essiv_cleanup(void)
> -{
> -	crypto_free_shash(essiv_hash_tfm);
> -}
> -
>  /*
>   * Given the encryption mode and key (normally the derived key, but for
>   * FS_POLICY_FLAG_DIRECT_KEY mode it's the master key), set up the inode's
> 


-- 
chandan



