Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397DC437EF5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Oct 2021 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhJVUB4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Oct 2021 16:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhJVUB4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Oct 2021 16:01:56 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4201AC061764
        for <linux-fscrypt@vger.kernel.org>; Fri, 22 Oct 2021 12:59:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r2so4242751pgl.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 22 Oct 2021 12:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qY1BZeI5POuERI11qKEcs4RSdS1A5Jda8Gfc5VjH1Y0=;
        b=qpnzO/vOO9FDQsF0rbKAz4gUb+I26z9Eh5PbFSktLG+1C6QvPyH5xynwCcYlkba3HA
         7M4RRul94L/OOcvErFKXkfv8qnIxFA3pcZimWIxCszRruzJuKvKXw9z5ypuS/E3Y3leC
         dG8UVqwcH1+1b3KYIG7AL7i62JJK3bIsrhJhpgItredmt7s8+Dkymg4b9PxHZGOim+1w
         iyhLHZc1CuzWSgcT7nneVnJ0NVA8trACgzJtyAp6WB5P9/D0gaoctc4YR4lBeqjXOI3U
         bfdR+0lw++Sa8mr9kxe0u9reWYS01FHSq++rKVCcoAl/jFslj2Zh/yptndHjjAO5O/iY
         m/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qY1BZeI5POuERI11qKEcs4RSdS1A5Jda8Gfc5VjH1Y0=;
        b=FCxcoTEGcnm+NpBmGQca3vXQAFVDCY6vA7NQkUC79LbBBqFSMXqX0e6zloMKqf3N55
         YulJTaso7p8eXZkqQAJB41vnVLI1P2efprDBcknrDJxYq4ORJQferxgridGydDEIHMle
         4vPZNNCVRO/ulQvmGoRhJ6D+h+TQFKCR89kdpIqJpr1UEQV5NtmQayBCTKEMeZH/QsNA
         Q8GlyNPzajNG/M7JMARxhxtfQBa9Pt2HpU0nwGT7UzRBGQrF8lmWj6ENQP88WvGzdWNT
         72JLriQ6wo9dK3eAbdfLYhOiGsKVDSR+bZkYmLQj+S7QeOSCB1J/iVwiuhokTmbBcVSO
         Vw1A==
X-Gm-Message-State: AOAM533Dq5hSFo9gxGu3E4ofcRFfIzsYrrL7bQiXNZ3jvrQlcRka9QuB
        exkHUUS81r4imdEr+3HZD1U3Zg==
X-Google-Smtp-Source: ABdhPJxohfdq1ij7Jk/RUNVnEnV1sKrOFH1BZvfRPO1ObZuBiSKjWA3l+yrLksPps6yehFRyTfR2DA==
X-Received: by 2002:a63:9557:: with SMTP id t23mr1348700pgn.428.1634932777612;
        Fri, 22 Oct 2021 12:59:37 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:7904])
        by smtp.gmail.com with ESMTPSA id k3sm13601158pjg.43.2021.10.22.12.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 12:59:37 -0700 (PDT)
Date:   Fri, 22 Oct 2021 12:59:35 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Vadim Akimov <lvd.mhm@gmail.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, kernel-team@fb.com
Subject: Re: Btrfs Fscrypt Design Document
Message-ID: <YXMYJ9nOd/88T8gc@relinquished.localdomain>
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
 <CAMnT83tLqZU-bdsOJX9L==c82EvmQ2QTiOYCLch=kasscU+MiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMnT83tLqZU-bdsOJX9L==c82EvmQ2QTiOYCLch=kasscU+MiA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 22, 2021 at 10:14:11PM +0300, Vadim Akimov wrote:
> Hi!
> 
> On Thu, 21 Oct 2021 at 21:34, Omar Sandoval <osandov@osandov.com> wrote:
> 
> > Here is the Google Doc:
> >
> > https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit?usp=sharing
> >
> 
> As I've understood, you are inclined to have single key and only change IV
> for each extent. This might be dangerous as per this answer (and comments
> below):  https://crypto.stackexchange.com/a/70630/71448

Correct me if I'm wrong, but I don't think this is a practical concern
in the fscrypt threat model. The birthday bound for AES is 256 EiB
(2^(128 / 2) blocks * 16 bytes per block). The theoretical maximum size
of a Btrfs filesystem is 16 EiB (since we use 64-bit byte addresses).
fscrypt protects against a "single point-in-time permanent offline
compromise". This means that the attacker only has what was on disk at
the time that they stole your disk. In this case, they won't have enough
data for a birthday attack. I'm curious where that post got the
"multiple petabytes" number.
