Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C9E7489C8
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jul 2023 19:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjGERBD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 Jul 2023 13:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjGERBD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 Jul 2023 13:01:03 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E0410F7;
        Wed,  5 Jul 2023 10:01:01 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8C9FF8360F;
        Wed,  5 Jul 2023 13:00:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688576460; bh=lBXFkMhEVvPhHNKR/KJoWQ6+31Bh4WdU5NQjrrqppcc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RLY0duUPSqYIeRDqvpgYHKVL7vLKnwKTbgK32DhR4D+5b/jAkISDy4zA/I4AhZoU5
         z5vPIKiKmpAZqUgqPaGzXDtpF/hS8CbwcMMoffOSksRwjW+asyxEcm7AdtpyEoS74J
         brBfZepcMUau8huPY8lnkQzXPCgyjd+jm5YF3BG/6oEA9O18E/U9ozU48z18hwbdmh
         vR2hzp4RusVGdSuPvDTrjEe0mNxbH2MMMWA6c73V4kk0Ua4LJ+uFzon+ORlbsiYpcz
         +fSfhPx//SXDuvSC+/wcQt6ma3VRZD3xr5zA9eUUmJ2RaR7sq5EZOlr+PYq/gmxHU0
         mTvnq/NlTPaAA==
Message-ID: <8711baa8-0a8c-934e-8880-e1c611a6b350@dorminy.me>
Date:   Wed, 5 Jul 2023 13:00:56 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 00/12] fscrypt: add extent encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, Neal Gompa <ngompa13@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
 <20230703045417.GA3057@sol.localdomain>
 <712d5490-8f36-f41d-4488-91e86e694cad@dorminy.me>
 <20230703181745.GA1194@sol.localdomain>
 <6a7d0d4a-9c79-e47d-7968-e508c266407d@dorminy.me>
 <20230704002854.GA860@sol.localdomain>
 <9c589884-d033-f277-58bf-735ba9120f14@dorminy.me>
 <CAEg-Je_zGBAgPLgpnjWbRwGLXNSpmor-mokZyMT6iSfF2121QQ@mail.gmail.com>
 <20230705162808.GA2003@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230705162808.GA2003@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>> I like creating containers directly based on my host system for
>> development and destructive purposes. It saves space and is incredibly
>> useful.
> 
> A solution for that already exists.  It's called btrfs snapshots.  Which you
> probably already know, since it's probably what you're using :-)
> 
> Using overlayfs would simply mean that each container consists of an upper and
> lower directory instead of a single directory.  Either or both could still be
> btrfs subvolumes.  They could even be on the same subvolume.

This isn't a full response, still researching details of our setup and 
whether overlayfs could work for us. But in re this particular usecase:

as I understand it, the lower layer for overlayfs is immutable. So if 
you set up a container/VM image in this way with overlayfs, you end up 
not being able to reclaim space from the original image, if e.g. you 
uninstall or upgrade a package present in the original.

This wastes disk space, and, if you want to migrate that subvol over to 
another machine/disk via btrfs send/receive, wastes network/CPU. 
Hopefully not a lot -- hopefully your container image is mostly 
immutable -- but for long-lived VMs like I usually use personally it 
could be basically the whole VM image wasted.
