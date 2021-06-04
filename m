Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A8C39C38E
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Jun 2021 00:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDWyV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 18:54:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:51692 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFDWyV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 18:54:21 -0400
IronPort-SDR: g5ZdvvP1x5r0Kw+O29X1VlspnH2e1LyBc/MmzWRgDSGGld513siwTJenpCSdErm5CGiB+D2Bbp
 bhajyfzOldAg==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="204412702"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="gz'50?scan'50,208,50";a="204412702"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 15:52:32 -0700
IronPort-SDR: a2jKl4QDCX03KjcTPAkAgA9JxTis33e7QIwOrzFP3ORPzFhYDHP6NBBjAGFo5g1VmoqPpkKojd
 8XN96ZyAMd2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="gz'50?scan'50,208,50";a="412513627"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2021 15:52:28 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lpIg0-00079f-5r; Fri, 04 Jun 2021 22:52:28 +0000
Date:   Sat, 5 Jun 2021 06:51:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Satya Tangirala <satyat@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Chao Yu <yuchao0@huawei.com>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 5/9] block: Make bio_iov_iter_get_pages() respect
 bio_required_sector_alignment()
Message-ID: <202106050654.2dIHanZf-lkp@intel.com>
References: <20210604210908.2105870-6-satyat@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20210604210908.2105870-6-satyat@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Satya,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on block/for-next]
[also build test ERROR on ext4/dev f2fs/dev-test linus/master v5.13-rc4 next-20210604]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Satya-Tangirala/add-support-for-direct-I-O-with-fscrypt-using-blk-crypto/20210605-051023
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/eea1225f680da16dce01bfb2914b9e8b78de298d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Satya-Tangirala/add-support-for-direct-I-O-with-fscrypt-using-blk-crypto/20210605-051023
        git checkout eea1225f680da16dce01bfb2914b9e8b78de298d
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:14,
                    from include/asm-generic/bug.h:20,
                    from ./arch/um/include/generated/asm/bug.h:1,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:9,
                    from block/bio.c:5:
   block/bio.c: In function 'bio_iov_iter_get_pages':
>> block/bio.c:1131:10: error: implicit declaration of function 'bio_required_sector_alignment' [-Werror=implicit-function-declaration]
    1131 |          bio_required_sector_alignment(bio));
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/math.h:14:46: note: in definition of macro '__round_mask'
      14 | #define __round_mask(x, y) ((__typeof__(x))((y)-1))
         |                                              ^
   block/bio.c:1130:20: note: in expansion of macro 'round_down'
    1130 |  aligned_sectors = round_down(bio_sectors(bio),
         |                    ^~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/bio_required_sector_alignment +1131 block/bio.c

  1083	
  1084	/**
  1085	 * bio_iov_iter_get_pages - add user or kernel pages to a bio
  1086	 * @bio: bio to add pages to
  1087	 * @iter: iov iterator describing the region to be added
  1088	 *
  1089	 * This takes either an iterator pointing to user memory, or one pointing to
  1090	 * kernel pages (BVEC iterator). If we're adding user pages, we pin them and
  1091	 * map them into the kernel. On IO completion, the caller should put those
  1092	 * pages. For bvec based iterators bio_iov_iter_get_pages() uses the provided
  1093	 * bvecs rather than copying them. Hence anyone issuing kiocb based IO needs
  1094	 * to ensure the bvecs and pages stay referenced until the submitted I/O is
  1095	 * completed by a call to ->ki_complete() or returns with an error other than
  1096	 * -EIOCBQUEUED. The caller needs to check if the bio is flagged BIO_NO_PAGE_REF
  1097	 * on IO completion. If it isn't, then pages should be released.
  1098	 *
  1099	 * The function tries, but does not guarantee, to pin as many pages as
  1100	 * fit into the bio, or are requested in @iter, whatever is smaller. If
  1101	 * MM encounters an error pinning the requested pages, it stops. Error
  1102	 * is returned only if 0 pages could be pinned. It also ensures that the number
  1103	 * of sectors added to the bio is aligned to bio_required_sector_alignment().
  1104	 *
  1105	 * It's intended for direct IO, so doesn't do PSI tracking, the caller is
  1106	 * responsible for setting BIO_WORKINGSET if necessary.
  1107	 */
  1108	int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
  1109	{
  1110		int ret = 0;
  1111		unsigned int aligned_sectors;
  1112	
  1113		if (iov_iter_is_bvec(iter)) {
  1114			if (bio_op(bio) == REQ_OP_ZONE_APPEND)
  1115				return bio_iov_bvec_set_append(bio, iter);
  1116			return bio_iov_bvec_set(bio, iter);
  1117		}
  1118	
  1119		do {
  1120			if (bio_op(bio) == REQ_OP_ZONE_APPEND)
  1121				ret = __bio_iov_append_get_pages(bio, iter);
  1122			else
  1123				ret = __bio_iov_iter_get_pages(bio, iter);
  1124		} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
  1125	
  1126		/*
  1127		 * Ensure that number of sectors in bio is aligned to
  1128		 * bio_required_sector_align()
  1129		 */
  1130		aligned_sectors = round_down(bio_sectors(bio),
> 1131					     bio_required_sector_alignment(bio));
  1132		iov_iter_revert(iter, (bio_sectors(bio) - aligned_sectors) << SECTOR_SHIFT);
  1133		bio_truncate(bio, aligned_sectors << SECTOR_SHIFT);
  1134	
  1135		/* don't account direct I/O as memory stall */
  1136		bio_clear_flag(bio, BIO_WORKINGSET);
  1137		return bio->bi_vcnt ? 0 : ret;
  1138	}
  1139	EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
  1140	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--uAKRQypu60I7Lcqm
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--uAKRQypu60I7Lcqm--
