Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D380DBD513
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Sep 2019 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411077AbfIXWru (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 24 Sep 2019 18:47:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33292 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410594AbfIXWrt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 24 Sep 2019 18:47:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OMhg6f139639;
        Tue, 24 Sep 2019 22:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=EdXU7HVLTeocrlfevZTVHOzeNjGSdcEE4UTi1407lv8=;
 b=GY5jE5RwpGb065Ob9L76il8TRurNhHyVBokcHu2ilo8wmtu3zSTxhT7MvuIoRDXUH3mY
 DWlLs/RiP3/5Zdag0Toa2W32jb40KT7h8Z6A4TEl/3Qg25Tz7f+dPRSkJDVJFX7GQeFO
 +sBYfRTuio2PiENi2eW4YBiApy9N0UmiZJR9/d1I+pgSfSsy9jYGQY2dDjkm3vVOktfJ
 ZhO4v3n96Fb6qgDefU9fz1+S3cHZRBvDW6Xfb2M3duugmitRicvt/cheSxq4lvuCr0nl
 arpolpg0rP8obSHzPBuzT20MEFkwkw/YwZs1vfm7YG7hNgn0IZBfZGbw/VJPXooFyks0 JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9ts60x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 22:47:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8OMcplP060579;
        Tue, 24 Sep 2019 22:47:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v6yvmn863-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 22:47:46 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8OMljTN001803;
        Tue, 24 Sep 2019 22:47:45 GMT
Received: from localhost (/10.159.232.132)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Sep 2019 15:47:45 -0700
Date:   Tue, 24 Sep 2019 15:47:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 3/8] xfs_io/encrypt: add new encryption modes
Message-ID: <20190924224744.GD2229799@magnolia>
References: <20190812175635.34186-1-ebiggers@kernel.org>
 <20190812175635.34186-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812175635.34186-4-ebiggers@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240182
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 12, 2019 at 10:56:29AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add new encryption modes: AES-128-CBC and AES-128-CTS (supported since
> Linux v4.11), and Adiantum (supported since Linux v5.0).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  io/encrypt.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io/encrypt.c b/io/encrypt.c
> index ac473ed7..11eb4a3e 100644
> --- a/io/encrypt.c
> +++ b/io/encrypt.c
> @@ -156,7 +156,7 @@ set_encpolicy_help(void)
>  " -v VERSION -- version of policy structure\n"
>  "\n"
>  " MODE can be numeric or one of the following predefined values:\n"
> -"    AES-256-XTS, AES-256-CTS\n"
> +"    AES-256-XTS, AES-256-CTS, AES-128-CBC, AES-128-CTS, Adiantum\n"

What do you think of generating the list of predefined values from
the available_modes[] array?  Then you wouldn't have to keep the help
text in sync with the C definitions, since it's not like there's a
meaningful translation for them anyway.

--D

>  " FLAGS and VERSION must be numeric.\n"
>  "\n"
>  " Note that it's only possible to set an encryption policy on an empty\n"
> @@ -170,6 +170,9 @@ static const struct {
>  } available_modes[] = {
>  	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
>  	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
> +	{FSCRYPT_MODE_AES_128_CBC, "AES-128-CBC"},
> +	{FSCRYPT_MODE_AES_128_CTS, "AES-128-CTS"},
> +	{FSCRYPT_MODE_ADIANTUM, "Adiantum"},
>  };
>  
>  static bool
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
