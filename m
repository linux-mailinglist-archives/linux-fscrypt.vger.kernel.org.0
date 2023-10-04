Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45787B8590
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Oct 2023 18:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbjJDQoT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjJDQoS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 12:44:18 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512AB9B
        for <linux-fscrypt@vger.kernel.org>; Wed,  4 Oct 2023 09:44:15 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5a229ac185aso27984847b3.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 04 Oct 2023 09:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696437854; x=1697042654; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I2if2iM6EGws4IARNzJAuoshxU4FqGDhSF3pEDm7d7Q=;
        b=kfrFb/5vsv65eCXxGeSdVxze4xDAyZDSuckqB2O8FLbyPYtKeYyYOpk3Fdukin0+B+
         9wFDhrWylTwi/Hu4N5v9S1sBlVs+gG9TkHvUwx1160oViwx+jT0lWzXmdsRIk2cfSMGy
         lsBRSoqFpf+nsAdJI9nlN6lXwnCmINgwHIZg+uSXCslCq2KnevABLeZEuQHuxeeOGkvk
         ehxt13xKSctgCqFI97MjIB/MAvF50F9jkKZndCDF8ejq48HUV6xLb3HuvfTg8HPh95Yg
         tSiq3EJvCI/r67QZuRKNxJ+mFp+Vz+BoBI6HldYsCEY3PqtkLf/UcHqu2HZSVpXEp98J
         tlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696437854; x=1697042654;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2if2iM6EGws4IARNzJAuoshxU4FqGDhSF3pEDm7d7Q=;
        b=kA5LvIWH/0MWNs5htyS9OtyywCQRyN8PPN9ghuNcLHWy/nj43lJl/1qR8Kg5sZj31o
         0v+nycx8EE/2dgKsP6urIHRzHDnQIaNi2knu/8QHBEDVx3OInHM7yQlOEaa0zlnUR/d6
         XaAE6jPROcgzLI/d4SqiDKUoCn11AdFTo5iA+B5uRZPt8tenL3gv7BDmLsV+GgD0tDvP
         I7KpgbvXw9/IWt8ljl/at+o78L+UMKQ4lGSJTwhZTqIJnV6VRDniWFgYELTXybDiDM3O
         wW0CcbJ2C5KA88fc1KwLrxz9x5E9ZpuYaJMRFx/3yGMV6uVhGVBSjTJcE/i3EvpMe8Fo
         GXbw==
X-Gm-Message-State: AOJu0YyJLQCHCs8CadpOlQe1ObZ0Zh+wuNPCGP4q2o+aY0fpH2MzATBn
        Pann75GpgJVXmcyD2ZguOhOErg==
X-Google-Smtp-Source: AGHT+IE4YjR68xXnXd7rYcGClYleMtC0WnYuLBTfMzqeBxFFH/S/Wk0pB4fIHKHJfTqLmCINlDqudw==
X-Received: by 2002:a0d:df12:0:b0:570:7b4d:f694 with SMTP id i18-20020a0ddf12000000b005707b4df694mr3237209ywe.3.1696437854399;
        Wed, 04 Oct 2023 09:44:14 -0700 (PDT)
Received: from localhost (144-129-254-068.biz.spectrum.com. [144.129.254.68])
        by smtp.gmail.com with ESMTPSA id n133-20020a81728b000000b005777a2c356asm1243457ywc.65.2023.10.04.09.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 09:44:13 -0700 (PDT)
Date:   Wed, 4 Oct 2023 12:44:12 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     ebiggers@kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        sweettea-kernel@dorminy.me
Subject: Master key removal semantics
Message-ID: <20231004164412.GA363973@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

While getting the fstests stuff nailed down to deal with btrfs I ran into
failures with generic/595, specifically the multi-threaded part.

In one thread we have a loop adding and removing the master key.

In the other thread we have us trying to echo a character into a flie in the
encrypted side, and if it succeeds we echo a character into a temporary file,
and then after the runtime has elapsed we compare these two files to make sure
they match.

The problem with this is that btrfs derives the per-extent key from the master
key at writeout time.  Everybody else has their content key derived at flie open
time, so they don't need the master key to be around once the file is opened, so
any writes that occur while that file is held open are allowed to happen.

Sweet Tea had some changes around soft unloading the master key to handle this
case.  Basically we allow the master key to stick around by anybody who may need
it who is currently open, and then any new users get denied.  Once all the
outstanding open files are closed the master key is unloaded.

This keeps the semantics of what happens for everybody else.

What is currently happening with my version of the patchset, which didn't bring
in those patches, is that you get an ENOKEY at writeout time if you remove the
key.  The fstest fails because even tho we let you write to the file sometimes,
it doesn't necessarily mean it'll make it to disk.

If we want to keep the semantics of "when userspace tells us to throw away the
master key, we absolutely throw the master key away" then I can just make
adjustments to the fstests test and call what I have good enough.

If we want to have the semantics of "when userspace tells us to throw away the
master key we'll make it unavailable for any new users, but existing open files
operate as normal" then I can pull in Sweet Tea's soft removal patches and call
it good enough.

There's a third option that is a bit of a middle ground with varying degrees of
raciness.  We could sync the file system before we do the removal just to narrow
the window where we could successfully write to a file but get an ENOKEY at
writeout time.  We could freeze the filesystem to make sure it's sync'ed and
allow any current writers to complete, this would be a stronger version of the
first option, again just narrows the window.  Neither of these cases help if the
file is being held open.  If we wanted to fully deal with the file being held
open case we could set a flag, sync, then remove the key.  Then we add a new
fscrypt_prep_write() hook that filesystems could optionally use, obviously just
btrfs for now, that we'd stick in the write path that would check for this flag
or if the master key had been removed so we can deny dirtying when the key is
removed.

At this point I don't have strong opinions, it's easier for me to just leave it
like it is and change fstests.  Anything else is a change in the semantics of
how the master key is handled, and that's not really a decision I feel
comfortable making for everybody.  Once we nail this detail down I can send the
updated version of all the patches and we can start talking about inclusion.
Thanks,

Josef
