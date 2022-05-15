Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB505275C4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 06:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiEOEtf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 00:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbiEOEte (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 00:49:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAD9655D;
        Sat, 14 May 2022 21:49:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c14so11218284pfn.2;
        Sat, 14 May 2022 21:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GMvKqZE/o42rCp71Di1k/rccnb5+5sI5P1y+ZV/ra5g=;
        b=irSbRVBH1tkN1riCzpXSH0SH94U8V8NjmEgM3pGHK5u/Jqd0ISw1UBvmo40gkooV31
         yBwLq0KNjkEomRtFrlreKMLjlAIy9QLWOnf6Ug276ZTUvUkh6gsJ6igyyWOUxM+jYtRr
         4J0+z6jzSqLoAjD+lWKnCc6izhLnEg1IZc+eYGMJaU4xiTQyykKzplTGVnQ4aMJ0TU2q
         cUsKqn0Cy5rc3DOFYxJX5YDF9Bspt6FPnxJGjealISAqY9XVZ7cpJ6Ic59u39Vuw6ogj
         xlhvoRMSLLI2SGS0XIIhMMSLD6EiRta6KB6HpB6nMNRJbUMgSASdQ702tN5w/34P89eY
         JL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GMvKqZE/o42rCp71Di1k/rccnb5+5sI5P1y+ZV/ra5g=;
        b=z0Qkg58xSWUsuemSqMBzs/BXMteDQOeM8Q2AioCldcZMUUV7yF9E4Ha0Bx9kHrlM/p
         PY3j5dXzpokHfH9RqBZ2uBS/AeWqB6E1jCujDFNQxMtZzCaSajIApU12z1GZ82lUn4J7
         f+R+u7sg0fa++X8spzfDy3zOk6iA3mBNKs33iPRK0LucSxyghluEiqGJ0yyShSjC5nlH
         U8yW6+GYEk3OGEFo0ii3/zkQs7CZ/cYjj3Vi649AdU+vIKi87cijauByxKnNF6y4+PSs
         hJSXOjB6w/ITR4wEUN0zsPGJe5z4aL7V30X/cRdj9Ppz0+9Ma+PFQZO0F3F2vq0726q8
         oBRg==
X-Gm-Message-State: AOAM531VqhK3p2NVDNa60+YdVikrXBH8+4gXb/lK+Cgrko7CalHaeKsx
        4YZv9AwwUlLWKMbKPBqu55c=
X-Google-Smtp-Source: ABdhPJzamu6Z6OefbpU9Th9e+XseXLLIicRBltib9pUknNb36kPBykVDJkPlVyA5MtcMAHq9/gWNBQ==
X-Received: by 2002:a65:6b8e:0:b0:39d:6760:1cd5 with SMTP id d14-20020a656b8e000000b0039d67601cd5mr10398220pgw.379.1652590171157;
        Sat, 14 May 2022 21:49:31 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709029a8800b0015e8d4eb23asm4458425plp.132.2022.05.14.21.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 21:49:30 -0700 (PDT)
Date:   Sun, 15 May 2022 10:19:26 +0530
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv2 2/3] ext4: Cleanup function defs from ext4.h into
 crypto.c
Message-ID: <20220515044926.l2dg2jh7i3ujkmsc@riteshh-domain>
References: <cover.1652539361.git.ritesh.list@gmail.com>
 <4120e61a1f68c225eb7a27a7a529fd0847270010.1652539361.git.ritesh.list@gmail.com>
 <YoB2Glboi8Kcu+Ak@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoB2Glboi8Kcu+Ak@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 22/05/14 08:40PM, Eric Biggers wrote:
> On Sat, May 14, 2022 at 10:52:47PM +0530, Ritesh Harjani wrote:
> > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> [...]
> > +int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
> > +			      int lookup, struct ext4_filename *fname)
> > +{
> [...]
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> [...]
> > +int ext4_fname_setup_filename(struct inode *dir,
> > +			      const struct qstr *iname, int lookup,
> > +			      struct ext4_filename *fname);
>
> Very minor nit: the above declaration can be formatted on 2 lines, the same as
> the definition.

Thanks for spotting. I will make the change.

>
> Otherwise this patch looks fine.  I think that filename handling in ext4 in
> general is still greatly in need of some cleanups, considering that ext4 now has
> to support all combinations of encryption and casefolding.  f2fs does it in a
> somewhat cleaner way, IMO.  And it's possible that would lead us down a slightly
> different path.  But this is an improvement for now.

Some examples please which you posibly have in mind which should help in
cleanup ext4's filename handling code. I can get back to it after completing
some other items in my todo list.

>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thanks!!

-ritesh
