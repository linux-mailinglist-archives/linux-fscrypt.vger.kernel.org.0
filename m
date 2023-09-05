Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60067931CF
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Sep 2023 00:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjIEWKw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 5 Sep 2023 18:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjIEWKw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 5 Sep 2023 18:10:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDADCF4;
        Tue,  5 Sep 2023 15:10:48 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99c3c8adb27so455979366b.1;
        Tue, 05 Sep 2023 15:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693951847; x=1694556647; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMMSLis4hyTF9R8M2Kc4ctinkZBRnH/ky/JOZDJf7aU=;
        b=JIb0BlVCsvLda67jRMuL52xAhNz/SYoQAW72Tu8YQNpFpvE4SNbp9hICVBCpaVHDoC
         /fA6OVb1XvM5mQ0yG9bU5siihXiRNy+fbVhWmfCSxKWDkrvece5k8hzWNIEu8X1MCxmp
         KbIuaeUt9YgNuPar0cXO67Wqu5oWtfX7c+n/xeF56CZWB2VF4MUUEZuQ2NhTC47Br+wI
         YCEOPPAUFObweB2dnS3+BYLVTPnmYIvta0SQlJZaeHkx2wjoDn74fl8u7M+3wGSuNqcC
         lkHQoyXjSukiiLxZ6RWoZFQU+ecOURaVjsY1hLzWqAYMukK1TJTN1hDUcWiEHpbitJJR
         JoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693951847; x=1694556647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMMSLis4hyTF9R8M2Kc4ctinkZBRnH/ky/JOZDJf7aU=;
        b=T7lLP/jP0Ty14UyQHYJCCDpXYUo4URmL85AYT5gQP8vw4kKtFVTGtLguLLtYqtJl0Z
         X020a6Mf/9Ucia6jt7FIgWqMhb9a4yzSr9ITQZrg/x2WTK/xngvKIoefHJzSj9dQc/cV
         2gT9wbSxsqjS+U/TfvyFPEA9jCzgvxiXzyQCiMiEQdDiAMcaaR1tYZvQ/+WEHRIaLQMA
         c4daWlQNayIPskWlYBkjTnElgj0f8sSoS9tgJ087t/SxphlaB3008zCdPszly7u61Hrs
         tNvTs6zxBdbi2QPk6yEIaKSzglMDuvbWWdRJO+Zz1WqtmOWfaWRs7HkJm/FNvhrWpL25
         RGDA==
X-Gm-Message-State: AOJu0Yw2S7IamZZT/K8IWg17fCmtafuvEDyUsZDdSzRN1vPrwdHEIFtK
        4eVztnvkDGxBVjtuDRlLVt2odqJFBITKYD+fxWY=
X-Google-Smtp-Source: AGHT+IGZQ7/lskFj9+KqOscCelMYck8PyW2xvEhqXnVz0vBzJGlG1T3lqSLh+CE/cxi2Mfs3R9jiQIEbafG7kgshtcw=
X-Received: by 2002:a17:906:32c2:b0:9a1:c495:66bb with SMTP id
 k2-20020a17090632c200b009a1c49566bbmr898646ejk.60.1693951847136; Tue, 05 Sep
 2023 15:10:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1693630890.git.sweettea-kernel@dorminy.me> <e0263ab5998ddf723b78ed56a545490e482c29b9.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <e0263ab5998ddf723b78ed56a545490e482c29b9.1693630890.git.sweettea-kernel@dorminy.me>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Tue, 5 Sep 2023 18:10:10 -0400
Message-ID: <CAEg-Je9-w5Qb7eJ2s4UhF0u2WOtAtWe3m183UT-Bvg-Vh__hoA@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] fscrypt: store full fscrypt_contexts for each extent
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Sep 2, 2023 at 1:56=E2=80=AFAM Sweet Tea Dorminy
<sweettea-kernel@dorminy.me> wrote:
>
> For contrast purposes, this patch contains the entirety of the changes
> necessary to switch between lightweight and heavyweight extents. This
> patch could be dropped, or rolled into the former change, without
> changing anything else.
>
> Lightweight extents relying on their parent inode's context for
> key and policy information do take up less disk space. Additionally,
> they guarantee that if inode open succeeds, then all extents will be
> readable and writeable, matching the current inode-based fscrypt
> behavior.
>
> However, heavyweight extents permit greater flexibility for future
> extensions:
>
> - Any form of changing the key for a non-empty directory's
>   future writes requires that extents have some sort of policy in
>   addition to the nonce, which is essentially the contents of the full
>   fscrypt_context.
>   - This could be approximated using overlayfs writing to a new
>     encrypted directory, but this would waste space used by overwritten
>     data and makes it very difficult to have nested subvolumes each with
>     their own key, so it's very preferable to support this natively in
>     btrfs.
>
> - Scrub (verifying checksums) currently iterates over extents,
> without interacting with inodes; in an authenticated encryption world,
> scrub verifying authentication tags would need to iterate over inodes (a
> large departure from the present) or need heavyweight extents storing
> the necessary key information.
>

I've been thinking about this patch set a bit since it was posted, and
I've got some thoughts specifically about this.

A use-case that is extremely important to me is enabling background
encryption of parts or the whole filesystem, but also enabling
rekeying the encrypted data too. This can be necessary for a variety
of reasons. This is supported in LUKS/dm-crypt and I would like to
have this supported in Btrfs native encryption through fscrypt.

My understanding of this (after following all the discussions and
patch sets) is that heavyweight extents make this a fundamentally
cheaper and safer operation because there's no need to traverse
through the inodes and change them. This would be fairly expensive
and create a situation where inode sharing becomes much more limited
as rekeying occurs on active data while not occurring on old
snapshots, for example.

It's certainly a trade-off that leads to more complexity, but I think
it's worth it because key properties that people rely on with Btrfs
can be preserved even with encrypted data.



--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
