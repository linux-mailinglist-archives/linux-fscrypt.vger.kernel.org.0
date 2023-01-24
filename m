Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D2367A533
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Jan 2023 22:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbjAXVqS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 24 Jan 2023 16:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbjAXVqO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 24 Jan 2023 16:46:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F0351C56;
        Tue, 24 Jan 2023 13:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B05DB81710;
        Tue, 24 Jan 2023 21:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2990C433EF;
        Tue, 24 Jan 2023 21:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674596770;
        bh=tyYq5kUwEdbE7CszQ0qp7rYJOubbzA7XgZByp+TgBuE=;
        h=Date:From:To:Cc:Subject:From;
        b=a67hXsCak5/DDjwXlochSLbzo2jyntzGsVFzV6DfzO3Uo/VTQsvwwioY2Q6ILzTDn
         5DoKfDXpVNHePMTUA+BqAf6F8L4VxetlP4oJXnqYF2Z1in4OQsWr0b/vXSeANFC52Z
         +ae22Zi2kWJrQX8yFR1fCvnGkg/8UBgKGfOHtgW6OEaCjglObDt0R2H2mo5sNeh5lm
         DSZkMU7y5sTP2lSs4qsvxnaE7hTVOr+rYOLGlIRUfvBx4yHstQ+eiXIGqp5mn8XdPh
         ZKGCNwtyBFpjZcUKuw2gRKhIGJv3a3Yzl6e5dg2LeMJruHsg7c9UxVSRrtNN3Lxv90
         OVPsda5y3DQqA==
Date:   Tue, 24 Jan 2023 13:46:08 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev
Subject: Please update fscrypt and fsverity branches in linux-next
Message-ID: <Y9BRoE/SIg1aUh+P@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Stephen,

I've moved the fscrypt and fsverity development branches to split them up
properly and make it clear what each branch is for.  Therefore, can you please
remove the following branches from linux-next:

	Repo:      git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
	Branches:  master, for-stable, and fsverity

And please add the following branches to linux-next:

	Repo:      https://git.kernel.org/pub/scm/fs/fscrypt/linux.git
	Branches:  for-next and for-current

	Repo:      https://git.kernel.org/pub/scm/fs/fsverity/linux.git
	Branches:  for-next and for-current

Also please ensure the contacts match the corresponding MAINTAINERS file
entries.  For fscrypt that is:

	M:      Eric Biggers <ebiggers@kernel.org>
	M:      Theodore Y. Ts'o <tytso@mit.edu>
	M:      Jaegeuk Kim <jaegeuk@kernel.org>

and for fsverity that is:

	M:      Eric Biggers <ebiggers@kernel.org>
	M:      Theodore Y. Ts'o <tytso@mit.edu>

Thanks!

- Eric
