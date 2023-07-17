Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972887567C8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjGQPYb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjGQPYQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:24:16 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800DB1980
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:24:01 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-7654e1d83e8so377966985a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689607435; x=1692199435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Pg+RfHLkyJL7hGH0WFSKZx3Fe7nuWwYqh343zHyOmU=;
        b=FVgM7kquxZ62uvQ6Togai1+WHVRAZoz9OpP4FNseA7IpELhXesXq7ZvZJYxCraQqM9
         1XEymvQnkewBkO+XomhGXRHA3ujw4d21u5I0o5FSBkx3WE6G9V6oiknFwpQNtqH+1Nl9
         n2pGBb860tG0Pal5cx82+kpcNHOPneAE0uhuDecl5x6P4c/6x/v/T98O39O1Ars+QqrS
         HyEZ5Dym4Cn2km4rVTpo4Zsi5yj8OGtlkPE9KjYVixnBygs8tyf3Wlea/1DhGEa18zo3
         gGE4FOlonHBVTuh954Ou1ErOSaetSkjhSlFS9L+A6vqmJ8+EUr893vzcSHlGkVVh9R6N
         H6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607435; x=1692199435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Pg+RfHLkyJL7hGH0WFSKZx3Fe7nuWwYqh343zHyOmU=;
        b=AGIS43YJtVWnz4+Qjp9GaqindXzMIlwjapH1cS1G6WMzpepSBZbUUqH4YXGNBe7L3d
         Wow/1FQFaLb/4jsYZpWmg6lFPKKgTH8R1BwVCyM35V+krtW4hRK5S5nDt4uTYfPUtLFC
         aJUJkXEavPXVJHIRpl6FkmaDbvOjn1U5TS6s076xVFx2bnuCFH/5BZJZpRKkIspxVTak
         2DaVJeCcOzLBzb/GL4V0DroxHAWXOdQPI2qbW4jF9/jxaCBUb7PjO4qbg8uVEDAGb0WE
         8czh+u2qq1uhy2LUkCFKM0AmCblywr3XgsDjBoKomJq121G4S8fiUQkxacL1nb9ilqwe
         6/BQ==
X-Gm-Message-State: ABy/qLaBetcFOEkFCbhfPykXYCF7cowzSVj01qyzhjyNQZeHfVqHQGEw
        c+vAjEIO0OjiUxaXQ6caSmYXQI6iDO9/TVzlJ+bMXw==
X-Google-Smtp-Source: APBJJlFbU8kW2XjpvLyqmFxljtLqZj1Uzb9X7DLA9HKeVcGFaYYioU9UHNkhU26/vtE6gBm01QgWRg==
X-Received: by 2002:a0c:f0d2:0:b0:636:2fa5:fd78 with SMTP id d18-20020a0cf0d2000000b006362fa5fd78mr10721328qvl.30.1689607435552;
        Mon, 17 Jul 2023 08:23:55 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id e9-20020a05620a12c900b00767ccf42f3csm6162847qkl.66.2023.07.17.08.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 08:23:55 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:23:54 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/14] fscrypt: allow load/save of extent contexts
Message-ID: <20230717152354.GG691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <ad7186dd7b7a814a0d96452d48a92628f791cb35.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad7186dd7b7a814a0d96452d48a92628f791cb35.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:45PM -0400, Sweet Tea Dorminy wrote:
> The other half of using per-extent infos is saving and loading them from
> disk.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keysetup.c    | 50 ++++++++++++++++++++++++++++++++++++++++-
>  fs/crypto/policy.c      | 20 +++++++++++++++++
>  include/linux/fscrypt.h | 17 ++++++++++++++
>  3 files changed, 86 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index c8cdcd4fe835..3b80e7061039 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -847,7 +847,6 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
>  					    IS_CASEFOLDED(inode) &&
>  					    S_ISDIR(inode->i_mode),
>  					    NULL);
> -

Errant change.  Thanks,

Josef
