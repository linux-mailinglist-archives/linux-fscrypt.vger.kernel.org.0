Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F38789AD8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 27 Aug 2023 03:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjH0Bly (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 26 Aug 2023 21:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjH0Blp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 26 Aug 2023 21:41:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420171BB;
        Sat, 26 Aug 2023 18:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693100503; x=1724636503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SwkzD2XXqz25xBQj7+Qw+0ndFDroxkcAVZksTk/82zE=;
  b=dC08DkCT5x6B4IiQYJ7xM+AD2ZEvTUFtJH9zUGz/RqG1IKhp+75SSKOY
   Am/WMICCgWn2lnJ6DGSaTSF5LlcBmI/l5DhOgcAVYmhcwbKrPWm9fzqST
   Izl00RydOTdX8y6bIzPcxJ9HELeJDiBKqjbP8Q75oZ86ok8oiKTvdB0wQ
   oUwoxkX6lET291AIK+s0dC7yXXK45/1t76fGwbgddUbeUpOVin6h4PVeJ
   EEOLC58is3gpdwBaq8h9pkgMAF7Z6e5j7l8R9uHat7VPlJUMdM5F6QI99
   1BYEmEn3dpAl9WFs2L76QZmGD/b6fwruJ5dTWZR22GyZrZVSlXWH9u4Pa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10814"; a="373790138"
X-IronPort-AV: E=Sophos;i="6.02,204,1688454000"; 
   d="scan'208";a="373790138"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2023 18:41:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10814"; a="687707446"
X-IronPort-AV: E=Sophos;i="6.02,204,1688454000"; 
   d="scan'208";a="687707446"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2023 18:41:34 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qa4mT-0005GT-2s;
        Sun, 27 Aug 2023 01:41:33 +0000
Date:   Sun, 27 Aug 2023 09:40:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y.Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-inte@web.codeaurora.org, grity@vger.kernel.org,
        "Jason A.Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH 2/12] ubifs: Do not include crypto/algapi.h
Message-ID: <202308270908.Go1QPOZ7-lkp@intel.com>
References: <E1qYl9s-006vDm-IW@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qYl9s-006vDm-IW@formenos.hmeau.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master rw-ubifs/next rw-ubifs/fixes v6.5-rc7 next-20230825]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/fscrypt-Do-not-include-crypto-algapi-h/20230823-183716
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/E1qYl9s-006vDm-IW%40formenos.hmeau.com
patch subject: [PATCH 2/12] ubifs: Do not include crypto/algapi.h
config: x86_64-randconfig-r016-20230823 (https://download.01.org/0day-ci/archive/20230827/202308270908.Go1QPOZ7-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce: (https://download.01.org/0day-ci/archive/20230827/202308270908.Go1QPOZ7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308270908.Go1QPOZ7-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/ubifs/auth.c:12:0:
   include/linux/verification.h: In function 'system_keyring_id_check':
>> include/linux/verification.h:23:11: error: 'EINVAL' undeclared (first use in this function)
      return -EINVAL;
              ^~~~~~
   include/linux/verification.h:23:11: note: each undeclared identifier is reported only once for each function it appears in


vim +/EINVAL +23 include/linux/verification.h

817aef260037f3 Yannik Sembritzki 2018-08-16  19  
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  20  static inline int system_keyring_id_check(u64 id)
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  21  {
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  22  	if (id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
f3cf4134c5c6c4 Roberto Sassu     2022-09-20 @23  		return -EINVAL;
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  24  
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  25  	return 0;
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  26  }
f3cf4134c5c6c4 Roberto Sassu     2022-09-20  27  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
