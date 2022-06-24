Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6B55933A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jun 2022 08:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiFXGRJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jun 2022 02:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFXGRI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jun 2022 02:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63C9F4E3A3
        for <linux-fscrypt@vger.kernel.org>; Thu, 23 Jun 2022 23:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656051425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8zS3IsB2SxaWn7FKVotEVa/GMXmNG8HC49Y5sW0xw7I=;
        b=XHrPBc3I0XtQAG4q+NrObBrjIBz32iDp9AEhb2zXK39nl0ULnkNisoWDmnppz+SMSaQT6y
        L65jeI0e9BD4ydnM2hzGPD6H3ZOFB0sAOCwH72YHmvmBVWI+QbCP81sRLQIjTqE6WJOaW0
        EAiQhwCEgvrMEuUcs98FEkeWFq+nfk4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-fqWA7RbHOY2VGRw1Bkz3xw-1; Fri, 24 Jun 2022 02:17:04 -0400
X-MC-Unique: fqWA7RbHOY2VGRw1Bkz3xw-1
Received: by mail-qv1-f69.google.com with SMTP id m1-20020a0cf181000000b0046e65e564cfso1655325qvl.17
        for <linux-fscrypt@vger.kernel.org>; Thu, 23 Jun 2022 23:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8zS3IsB2SxaWn7FKVotEVa/GMXmNG8HC49Y5sW0xw7I=;
        b=iMwKuwI0Ng7mVlxha4YvaQzlQnvmZk4XCGIo9vi4wUwMn367AicDDwueofOlMtelhS
         yGrj3cem8S8bPcqa0rN0wKr/pXWwGm+ZFLwhjPWpj/YAhfLBpdl4gq6wa3x+LiWBg8PG
         BS/883ofhjW+OkRe0f/OK0zzJOjdmVk9gx1yJ3xgfaXB94fgTnF0kF8IexyuNfXyAtPc
         pfghtS8ve7K4zEHcGHmQigd51WTdbvlui6/43hweKTBqot5A11aclkSjHtFIz4m8ewE7
         wb9zZi9baSJ/gDv04apGf/Qcml6+MrksWttJaohRti1wqLik7dR53mq1+q44qHqTAs1q
         mxwQ==
X-Gm-Message-State: AJIora8HpubG5ny49r9+vfdG0ML43w4drkYpSGzkvGFEXvsF+HwlNluA
        q5IIH6k4J86guBfmS3I4pWNZf6kZb12KlC1z9vSAUcztSHTBYDVvqF8LiLwxEsp2fz1Iuvw6szo
        P1vMXrT8GYVa1Dudgrg/xGQrmQg==
X-Received: by 2002:ac8:5b50:0:b0:305:3275:b9bf with SMTP id n16-20020ac85b50000000b003053275b9bfmr11444076qtw.498.1656051423560;
        Thu, 23 Jun 2022 23:17:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vefrm2rq70JDwELgpQV2bt8QlwdFwZFZWBDiPit9fA/NxGoF8Ny8SVccrw7v0NjT1quM+67A==
X-Received: by 2002:ac8:5b50:0:b0:305:3275:b9bf with SMTP id n16-20020ac85b50000000b003053275b9bfmr11444063qtw.498.1656051423326;
        Thu, 23 Jun 2022 23:17:03 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f10-20020a05620a280a00b006a69d7f390csm1232878qkp.103.2022.06.23.23.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:17:02 -0700 (PDT)
Date:   Fri, 24 Jun 2022 14:16:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [xfstests PATCH v2] ext4/053: test changing
 test_dummy_encryption on remount
Message-ID: <20220624061657.snbyeebcpepwv5em@zlang-mailbox>
References: <20220623184113.330183-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623184113.330183-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 23, 2022 at 11:41:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The test_dummy_encryption mount option isn't supposed to be settable or
> changeable via a remount, so add test cases for this.  This is a
> regression test for a bug that was introduced in Linux v5.17 and fixed
> in v5.19-rc3 by commit 85456054e10b ("ext4: fix up test_dummy_encryption
> handling for new mount API").
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Thanks for reminding that, I'll merge this patch this week.

> 
> v2: added info about fixing commit, and added a Reviewed-by tag
> 
>  tests/ext4/053 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/ext4/053 b/tests/ext4/053
> index 23e553c5..555e474e 100755
> --- a/tests/ext4/053
> +++ b/tests/ext4/053
> @@ -685,6 +685,9 @@ for fstype in ext2 ext3 ext4; do
>  		mnt test_dummy_encryption=v2
>  		not_mnt test_dummy_encryption=bad
>  		not_mnt test_dummy_encryption=
> +		# Can't be set or changed on remount.
> +		mnt_then_not_remount defaults test_dummy_encryption
> +		mnt_then_not_remount test_dummy_encryption=v1 test_dummy_encryption=v2
>  		do_mkfs -O ^encrypt $SCRATCH_DEV ${SIZE}k
>  	fi
>  	not_mnt test_dummy_encryption
> 
> base-commit: 0882b0913eae6fd6d2010323da1dde0ff96bf7d4
> -- 
> 2.36.1
> 

