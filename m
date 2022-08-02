Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5771587E44
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Aug 2022 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiHBOkx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Aug 2022 10:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiHBOkx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Aug 2022 10:40:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B42DB7C6;
        Tue,  2 Aug 2022 07:40:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D41AD33DFE;
        Tue,  2 Aug 2022 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659451249;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MhH9tc5kK6qc8QpUgSxAvIdqIuXwASA35oQDhLmW3hc=;
        b=tzOqNRCQSge3CH80jxmD7Q/BxVXQDkFQAqive+XTdasozuwOEnLxByHMdIZAlhohJBWSah
        FvgCAsMnEP+Yvlz2BonawnCUqpwZT0iSzrYu2uK8mogqvHO9vIb2laW6RZ0et8/0o9DJlU
        xVQT/Ae3dKsptsRkOz4GJMg4BQdJlSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659451249;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MhH9tc5kK6qc8QpUgSxAvIdqIuXwASA35oQDhLmW3hc=;
        b=CHPcEpHmDgYrn4XKrazeYKyTaRMfyiyQkKGVWEsKRm+1xv3SksWO9qZQoSyRQJQ9OwYE/g
        EsVnr680fiJwSHBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9CD2E13A8E;
        Tue,  2 Aug 2022 14:40:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /wtQJXE36WJzewAAMHmgww
        (envelope-from <dsterba@suse.cz>); Tue, 02 Aug 2022 14:40:49 +0000
Date:   Tue, 2 Aug 2022 16:35:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     kernel test robot <lkp@intel.com>
Cc:     Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        kbuild-all@lists.01.org
Subject: Re: [PATCH v2] btrfs: send: add support for fs-verity
Message-ID: <20220802143547.GM13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, kernel test robot <lkp@intel.com>,
        Boris Burkov <boris@bur.io>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        kbuild-all@lists.01.org
References: <9bfbf3b43d2c2663d2e3f196810288fd83c0b52e.1659031503.git.boris@bur.io>
 <202207312226.d2uCDX53-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202207312226.d2uCDX53-lkp@intel.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 31, 2022 at 10:19:28PM +0800, kernel test robot wrote:
> Hi Boris,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kdave/for-next]
> [also build test ERROR on next-20220728]
> [cannot apply to fscrypt/fsverity linus/master v5.19-rc8]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> config: arc-randconfig-r025-20220731 (https://download.01.org/0day-ci/archive/20220731/202207312226.d2uCDX53-lkp@intel.com/config)
> compiler: arceb-elf-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/cd0224725d17f6e9ebabdddeea5bc5743a9250ae
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Boris-Burkov/btrfs-send-add-support-for-fs-verity/20220729-021228
>         git checkout cd0224725d17f6e9ebabdddeea5bc5743a9250ae
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash fs/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    fs/btrfs/send.c: In function 'process_new_verity':
> >> fs/btrfs/send.c:4926:28: error: 'struct super_block' has no member named 's_vop'; did you mean 's_op'?
>     4926 |         ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);
>          |                            ^~~~~
>          |                            s_op
>    fs/btrfs/send.c:4942:28: error: 'struct super_block' has no member named 's_vop'; did you mean 's_op'?
>     4942 |         ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
>          |                            ^~~~~
>          |                            s_op
> 
> 
> vim +4926 fs/btrfs/send.c
> 
>   4914	
>   4915	static int process_new_verity(struct send_ctx *sctx)
>   4916	{
>   4917		int ret = 0;
>   4918		struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
>   4919		struct inode *inode;
>   4920		struct fs_path *p;
>   4921	
>   4922		inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
>   4923		if (IS_ERR(inode))
>   4924			return PTR_ERR(inode);
>   4925	
> > 4926		ret = fs_info->sb->s_vop->get_verity_descriptor(inode, NULL, 0);

sb::s_vop is under ifdef CONFIG_FS_VERITY so you'll need to ifdef the
verity callbacks.

>   4927		if (ret < 0)
>   4928			goto iput;
>   4929	
>   4930		if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
>   4931			ret = -EMSGSIZE;
>   4932			goto iput;
>   4933		}
>   4934		if (!sctx->verity_descriptor) {
>   4935			sctx->verity_descriptor = kvmalloc(FS_VERITY_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
>   4936			if (!sctx->verity_descriptor) {
>   4937				ret = -ENOMEM;
>   4938				goto iput;
>   4939			}
>   4940		}
>   4941	
>   4942		ret = fs_info->sb->s_vop->get_verity_descriptor(inode, sctx->verity_descriptor, ret);
>   4943		if (ret < 0)
>   4944			goto iput;
>   4945	
>   4946		p = fs_path_alloc();
>   4947		if (!p) {
>   4948			ret = -ENOMEM;
>   4949			goto iput;
>   4950		}
>   4951		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
>   4952		if (ret < 0)
>   4953			goto free_path;
>   4954	
>   4955		ret = send_verity(sctx, p, sctx->verity_descriptor);
>   4956		if (ret < 0)
>   4957			goto free_path;
>   4958	
>   4959	free_path:
>   4960		fs_path_free(p);
>   4961	iput:
>   4962		iput(inode);
>   4963		return ret;
>   4964	}
>   4965	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
