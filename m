Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6E2587E59
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiHBOrb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 10:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbiHBOr1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 10:47:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D7A21E3C;
        Tue,  2 Aug 2022 07:47:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF95220872;
        Tue,  2 Aug 2022 14:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659451643;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gfyEfQQ78agePpMousHJ83N/7TLcZbonIAuT/iSJ5Es=;
        b=wBGNM/Y0q67SO5DmehkU26t6JskGx0SPVGwLmAB9ahDvqiVrAFCFCUJ/5uYwWtWbqaVSDV
        cU8P7Tt+cYGY6cZOj6XMs2xwAwr1wb0g93Qc0KD4Bz8+9kKuq8qfuUmOMniXhyWvIatIWY
        GlwIzp4GwhMXR9k2wIP+WX+US1NCl1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659451643;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gfyEfQQ78agePpMousHJ83N/7TLcZbonIAuT/iSJ5Es=;
        b=3li3KrdBAe6DSQegaA30XmycnTnsdjL6+jORNL3HLMwPBFbs0xuE40PhdSBRT/KCdIdlx0
        irk4+wFQ/OxvwDAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9348F13A8E;
        Tue,  2 Aug 2022 14:47:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L3fzIvs46WJ3fgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 02 Aug 2022 14:47:23 +0000
Date:   Tue, 2 Aug 2022 16:42:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     kernel test robot <lkp@intel.com>
Cc:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        kbuild-all@lists.01.org
Subject: Re: [PATCH v2] btrfs: send: add support for fs-verity
Message-ID: <20220802144221.GN13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, kernel test robot <lkp@intel.com>,
        Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        kbuild-all@lists.01.org
References: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
 <202207311836.xrPNTFhA-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202207311836.xrPNTFhA-lkp@intel.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 31, 2022 at 06:35:07PM +0800, kernel test robot wrote:
> Hi Boris,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on kdave/for-next]
> [also build test WARNING on next-20220728]
> [cannot apply to fscrypt/fsverity linus/master v5.19-rc8]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220731/202207311836.xrPNTFhA-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/cd0224725d17f6e9ebabdddeea5bc5743a9250ae
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
>         git checkout cd0224725d17f6e9ebabdddeea5bc5743a9250ae
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/btrfs/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> sparse warnings: (new ones prefixed by >>)
> >> fs/btrfs/send.c:4906:9: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected int len @@     got restricted __le32 [usertype] sig_size @@
>    fs/btrfs/send.c:4906:9: sparse:     expected int len
>    fs/btrfs/send.c:4906:9: sparse:     got restricted __le32 [usertype] sig_size

The types are compatible, should this use the get_unaligned_le32 or
what's the supposed fix?
